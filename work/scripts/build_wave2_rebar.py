#!/usr/bin/env python
"""Wave 2 builder: insert ReBarDxe.ffs into the target DXE FV (5C60F367)
inside the LZMA-compressed container of file 9E21FD93, without changing
any container size (pad the recompressed stream back to the original
section length). Offline sandbox build only - never flashes.

Usage: python work\\scripts\\build_wave2_rebar.py
"""
import os
import struct
import lzma
import shutil

IMG = os.path.join("work", "bios", "System_BIOS.bin")
OUTDIR = os.path.join("mods", "v02_rebar")
OUT = os.path.join(OUTDIR, "System_BIOS.bin")
FFS = os.path.join("tools", "ReBARUEFI_0.3", "ReBarDxe.ffs")

REBAR_GUID = struct.pack("<IHH", 0xA8EE1777, 0xA4F5, 0x4345) + bytes.fromhex("9DA413742084D31E")
FILE_GUID = struct.pack("<IHH", 0x9E21FD93, 0x9C72, 0x4C15) + bytes.fromhex("8C4BE77F1DB2D792")
FV_GUID = struct.pack("<IHH", 0x5C60F367, 0xA505, 0x419A) + bytes.fromhex("859E2A4FF6CA6FE5")


def u24(b, o):
    return b[o] | (b[o + 1] << 8) | (b[o + 2] << 16)


def fv_header_len(fv):
    return struct.unpack("<H", fv[0x30:0x32])[0]


def fv_files_start(fv):
    """First FFS file offset: past HeaderLength and any extended header."""
    hlen = fv_header_len(fv)
    ext = struct.unpack("<H", fv[0x34:0x36])[0]
    if ext:
        extsize = struct.unpack("<I", fv[ext + 16:ext + 20])[0]
        start = (ext + extsize + 7) & ~7
        return max(hlen, start)
    return hlen


def fv_walk(fv):
    """Yield (offset, size, type, guid_hex) of each FFS file until free space.

    Files are 8-byte aligned; short 0xFF runs between files are alignment
    padding, not free space. Free space = a 0xFF run at least a header long.
    """
    off = fv_files_start(fv)
    n = len(fv)
    while off + 24 <= n:
        if fv[off] == 0xFF:
            run = 0
            while off + run < n and fv[off + run] == 0xFF:
                run += 1
            if run >= 24:
                yield (off, n - off, 0xFF, "free space")
                return
            off = (off + 8) & ~7
            continue
        size = u24(fv, off + 20)
        ftype = fv[off + 18]
        g = fv[off:off + 16]
        gh = "%08X-%04X-%04X-%s" % (
            struct.unpack("<I", g[0:4])[0],
            struct.unpack("<H", g[4:6])[0],
            struct.unpack("<H", g[6:8])[0],
            g[8:].hex().upper())
        if size == 0 or off + size > n:
            yield (off, 0, 0xEE, "BAD-HEADER")
            return
        yield (off, size, ftype, gh)
        off = (off + size + 7) & ~7


def main():
    if os.path.exists(OUT):
        os.remove(OUT)
    os.makedirs(OUTDIR, exist_ok=True)

    data = bytearray(open(IMG, "rb").read())

    foff = data.find(FILE_GUID)
    assert foff > 0, "file 9E21FD93 not found"
    filesize = u24(data, foff + 20)
    sec_off = foff + 24
    secsize = u24(data, sec_off)
    assert data[sec_off + 3] == 0x02, "expected GUID-defined section"
    assert data[sec_off + 4:sec_off + 20] == (struct.pack("<IHH", 0xEE4E5898, 0x3914, 0x4259)
                                              + bytes.fromhex("9D6EDC7BD79403CF")), "expected EE4E5898 guid"
    comp_off = sec_off + 20
    prefix = bytes(data[comp_off:comp_off + 4])
    stream = bytes(data[comp_off + 4: sec_off + secsize])
    print("file 9E21FD93 @0x%X size=0x%X ; section size=0x%X prefix=%s"
          % (foff, filesize, secsize, prefix.hex()))

    dec = bytearray(lzma.decompress(stream, format=lzma.FORMAT_ALONE))
    print("decompressed: %d (0x%X)" % (len(dec), len(dec)))

    fv_off = dec.find(FV_GUID)
    fv_off -= 0x10  # volume GUID is 0x10 into the extended header area; recompute below
    # find FV start precisely: search for FileSystemGuid 8C8CE578
    fsg = struct.pack("<IHH", 0x8C8CE578, 0x8A3D, 0x4F1C) + bytes.fromhex("9935896185C32DD3")
    fv_start = dec.find(fsg) - 0x10
    assert fv_start >= 0, "FV filesystem guid not found"
    fv_len = struct.unpack("<I", dec[fv_start + 0x20:fv_start + 0x24])[0]
    print("FV @ dec offset 0x%X len=0x%X" % (fv_start, fv_len))

    fv = dec[fv_start:fv_start + fv_len]
    # robust free-space detection: trailing 0xFF run at the end of the FV
    fv_end = fv_start + fv_len
    p = fv_end
    while p > fv_start and dec[p - 1] == 0xFF:
        p -= 1
    free_off = p - fv_start
    free_size = fv_end - p
    print("trailing free space @ FV 0x%X size=0x%X (%d) 8-aligned=%s"
          % (free_off, free_size, free_size, p % 8 == 0))
    assert set(dec[p:fv_end]) == {0xFF}, "trailing run not all 0xFF"
    # cross-check against known UEFITool offset
    assert free_off == 0x84B5D0, "unexpected free-space offset 0x%X" % free_off

    rebar = open(FFS, "rb").read()
    print("ReBarDxe.ffs size:", len(rebar))
    # verify it is a valid FFS with the expected GUID + checksum header
    assert rebar[0:16] == REBAR_GUID, "ReBarDxe.ffs GUID mismatch"
    rsize = rebar[20] | (rebar[21] << 8) | (rebar[22] << 16)
    print("rebar ffs: type=%02X attr=%02X size24=%d state=%02X"
          % (rebar[18], rebar[19], rsize, rebar[23]))
    assert rsize == len(rebar), "rebar ffs size field mismatch"

    # check it is not already present
    assert dec.find(REBAR_GUID) < 0, "ReBarDxe already present in FV"

    assert len(rebar) <= free_size, "not enough free space"

    # insert at free space start; fill the remainder of free space with 0xFF
    abs_off = fv_start + free_off
    dec[abs_off:abs_off + len(rebar)] = rebar
    remaining = free_size - len(rebar)
    dec[abs_off + len(rebar): abs_off + free_size] = b"\xFF" * remaining
    print("inserted; remaining free space = %d bytes" % remaining)

    # Recompress. liblzma always emits an end-marker plus an "unknown size"
    # (0xFFFF...) header. The vendor stream instead declares a KNOWN size and
    # carries no marker. Per EDK2 LzmaDecompress.c (GetDecodedSizeOfBuf reads
    # bytes 5..12 as a UINT32; LzmaDecode is called with LZMA_FINISH_END) a
    # known size is REQUIRED, and a trailing marker is tolerated: once the
    # output reaches the declared size the decoder either treats the clean end
    # as finished or decodes the following end-marker, returning before any
    # padding beyond it. So we (1) compress, (2) verify data+marker with
    # liblzma under the unknown-size header, (3) patch the header size field to
    # the true length for the BIOS SDK, (4) pad to the original section length.
    filters = [{"id": lzma.FILTER_LZMA1, "dict_size": 0x1000000, "lc": 3, "lp": 0, "pb": 2}]
    new_stream = bytearray(lzma.compress(bytes(dec), format=lzma.FORMAT_ALONE, filters=filters))
    assert lzma.decompress(bytes(new_stream), format=lzma.FORMAT_ALONE) == bytes(dec), "roundtrip failed"
    new_stream[5:13] = struct.pack("<Q", len(dec))
    new_stream = bytes(new_stream)
    old_stream_len = secsize - 20 - 4
    print("new compressed stream: %d ; old region: %d ; delta %+d"
          % (len(new_stream), old_stream_len, len(new_stream) - old_stream_len))
    if len(new_stream) > old_stream_len:
        raise SystemExit("recompressed stream larger than original - would need container rebuild")
    padded = new_stream + b"\x00" * (old_stream_len - len(new_stream))

    # write back (sizes unchanged)
    data[comp_off + 4: sec_off + secsize] = padded
    assert u24(data, sec_off) == secsize
    assert u24(data, foff + 20) == filesize

    open(OUT, "wb").write(data)
    print("wrote", OUT, len(data), "bytes")

    # --- self-verify by re-reading the output ---
    out = bytearray(open(OUT, "rb").read())
    ofoff = out.find(FILE_GUID)
    osecsize = u24(out, ofoff + 24)
    ostream = bytearray(out[ofoff + 48: ofoff + 24 + osecsize])
    ostream[5:13] = b"\xFF" * 8  # restore unknown-size header so liblzma decodes it
    decomp = lzma.LZMADecompressor(format=lzma.FORMAT_ALONE)
    odec = decomp.decompress(bytes(ostream))
    assert decomp.eof, "end-of-stream marker not reached"
    assert len(odec) == len(dec), "decompressed size changed"
    present = odec.find(REBAR_GUID)
    print("SELF-VERIFY: ReBarDxe GUID in rebuilt FV at dec offset 0x%X" % present)
    assert present > 0, "ReBarDxe missing after rebuild"
    diff = [i for i in range(len(dec)) if dec[i] != odec[i]]
    if diff:
        print("changed bytes: %d, range 0x%X..0x%X (intended 0x%X..0x%X)"
              % (len(diff), diff[0], diff[-1], abs_off, abs_off + free_size - 1))
        assert diff[0] >= abs_off and diff[-1] < abs_off + free_size, "unexpected bytes changed"
    print("OK")


if __name__ == "__main__":
    main()
