#!/usr/bin/env python
"""Probe the AMI LZMA container that holds the ReBAR target FV (5C60F367)."""
import struct
import lzma
import sys

IMG = r"work\bios\System_BIOS.bin"
data = open(IMG, "rb").read()

GUID_FILE = bytes.fromhex("93FD219E729C154CE77F1DB2D792".replace(" ", ""))
# 9E21FD93-9C72-4C15-8C4B-E77F1DB2D792 in EFI mixed-endian
guid_bytes = struct.pack("<IHH", 0x9E21FD93, 0x9C72, 0x4C15) + bytes.fromhex("8C4BE77F1DB2D792")
print("looking for", guid_bytes.hex())
off = data.find(guid_bytes)
print("file GUID at file offset:", hex(off) if off >= 0 else "NOT FOUND")
if off < 0:
    sys.exit(1)

# FFS header (24 bytes)
ffs = data[off:off + 24]
size24 = ffs[20] | (ffs[21] << 8) | (ffs[22] << 16)
print("FFS: type=%02X attr=%02X state=%02X hdrchecksum=%02X size24=%s (0x%X)"
      % (ffs[18], ffs[19], ffs[23], ffs[16], size24, size24))
body = data[off + 24: off + 24 + (size24 - 24)]
print("body len:", len(body), "(expected", size24 - 24, ")")

# section header: 3-byte size + 1-byte type
sec_size = body[0] | (body[1] << 8) | (body[2] << 16)
sec_type = body[3]
sec_guid = body[4:20]
print("section: size=%s (0x%X) type=%02X guid=%s"
      % (sec_size, sec_size, sec_type, sec_guid.hex()))
g = struct.unpack("<IHH", sec_guid[:8])
print("section guid = %08X-%04X-%04X-%s" % (g[0], g[1], g[2], sec_guid[8:].hex()))

comp = body[20:20 + (sec_size - 20)]
print("compressed payload len:", len(comp))

# try to decompress
for fmt_name, fmt in [("ALONE", lzma.FORMAT_ALONE), ("RAW", lzma.FORMAT_RAW), ("XZ", lzma.FORMAT_XZ)]:
    try:
        if fmt == lzma.FORMAT_RAW:
            dec = lzma.decompress(comp, format=fmt,
                                  filters=[{"id": lzma.FILTER_LZMA1, "dict_size": 0x1000000}])
        else:
            dec = lzma.decompress(comp, format=fmt)
        print(f"decompress({fmt_name}) OK -> {len(dec)} bytes (0x{len(dec):X})")
        print("  first 32:", dec[:32].hex())
        # volume image section inside?
        vsize = dec[0] | (dec[1] << 8) | (dec[2] << 16)
        vtype = dec[3]
        print("  inner section: size=0x%X type=%02X" % (vsize, vtype))
        # nested FV
        fv = dec[4:4 + 0x78]
        zv = fv[:16]
        fsguid = fv[16:32]
        fg = struct.unpack("<IHH", fsguid[:8])
        fvlen = struct.unpack("<I", fv[32:36])[0]
        print("  FV filesystem guid = %08X-%04X-%04X-%s" % (fg[0], fg[1], fg[2], fsguid[8:].hex()))
        print("  FV length field = 0x%X" % fvlen)
        # find nested FV GUID 5C60F367 in decompressed data
        nb = struct.pack("<IHH", 0x5C60F367, 0xA505, 0x419A) + bytes.fromhex("859E2A4FF6CA6FE5")
        print("  5C60F367 nested FV GUID at:", hex(dec.find(nb)))
        # recompress test with LZMA1 alone
        enc = lzma.compress(dec, format=lzma.FORMAT_ALONE,
                            filters=[{"id": lzma.FILTER_LZMA1, "dict_size": 0x1000000}])
        print("  recompress(ALONE) -> %d bytes (orig compressed %d)" % (len(enc), len(comp)))
        dec2 = lzma.decompress(enc, format=lzma.FORMAT_ALONE)
        print("  round-trip identical:", dec2 == dec)
        break
    except Exception as e:
        print(f"decompress({fmt_name}) failed:", type(e).__name__, str(e)[:120])
