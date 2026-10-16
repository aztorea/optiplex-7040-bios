import struct, os

FFS = r"C:\Users\Ghost\Desktop\bestproject\tools\ReBARUEFI_0.3\ReBarDxe.ffs"
OUT = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\esp\ReBarDxe.efi"
data = open(FFS, "rb").read()
print(f"ffs size = {len(data)}")

guid = data[0:16]
def guid_str(b):
    d1 = struct.unpack("<I", b[0:4])[0]
    d2 = struct.unpack("<H", b[4:6])[0]
    d3 = struct.unpack("<H", b[6:8])[0]
    d4 = b[8:10].hex()
    d5 = b[10:16].hex()
    return f"{d1:08X}-{d2:04X}-{d3:04X}-{d4.upper()}-{d5.upper()}"
print("file guid   =", guid_str(guid))
integ = data[0x10:0x12]
ftype = data[0x12]
attr = data[0x13]
size = int.from_bytes(data[0x14:0x17], "little")
state = data[0x17]
print(f"integrity=0x{integ.hex()} type=0x{ftype:02X} attr=0x{attr:02X} size=0x{size:X} state=0x{state:02X}")

# parse section(s) starting at 0x18
off = 0x18
while off < len(data) and off < size:
    b0, b1, b2, stype = data[off], data[off+1], data[off+2], data[off+3]
    if b0 == 0xFF and b1 == 0xFF and b2 == 0xFF:
        sec_size = int.from_bytes(data[off+4:off+8], "little")
        hdr = 8
    else:
        sec_size = int.from_bytes(data[off:off+3], "little")
        hdr = 4
    body = data[off+hdr:off+sec_size]
    print(f"  section @0x{off:X}: type=0x{stype:02X} size=0x{sec_size:X} body={len(body)}")
    if stype == 0x10:  # PE32
        open(OUT, "wb").write(body)
        print("    -> wrote", OUT, f"({len(body)} bytes)")
        # PE check
        if body[:2] == b"MZ":
            peoff = struct.unpack("<I", body[0x3C:0x40])[0]
            sig = body[peoff:peoff+4]
            print(f"    MZ ok, PE sig={sig!r}")
    off += sec_size

print("exists:", os.path.exists(OUT))
