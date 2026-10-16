import struct, sys

IMG = r'work\bios\System_BIOS.bin'
img = open(IMG, 'rb').read()

VOLS = [
    ("vol0", 0x000000, 0x040000),
    ("vol1", 0x040000, 0x020000),
    ("vol2", 0x060000, 0x020000),
    ("vol3", 0x080000, 0x060000),
    ("vol4", 0x0E0000, 0x000000),  # placeholder
    ("vol5", 0x0E0000, 0x5A0000),
    ("vol6", 0x680000, 0x080000),
]
PROTECT_LO, PROTECT_HI = 0x0E0000, 0x462C00


def u24(b, o):
    return b[o] | (b[o + 1] << 8) | (b[o + 2] << 16)


def guid_h(g):
    return "%08X-%04X-%04X-%s" % (struct.unpack("<I", g[0:4])[0],
                                  struct.unpack("<H", g[4:6])[0],
                                  struct.unpack("<H", g[6:8])[0], g[8:].hex().upper())


def fv_files_start(fv):
    hlen = struct.unpack("<H", fv[0x30:0x32])[0]
    ext = struct.unpack("<H", fv[0x34:0x36])[0]
    if ext:
        extsize = struct.unpack("<I", fv[ext + 16:ext + 20])[0]
        return max(hlen, (ext + extsize + 7) & ~7)
    return hlen


def walk(fv):
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
        if size == 0 or off + size > n or size < 24:
            yield (off, size, 0xEE, "BAD @ " + g.hex())
            return
        yield (off, size, ftype, guid_h(g))
        off = (off + size + 7) & ~7


for name, base, ln in VOLS:
    if ln == 0:
        continue
    fv = img[base:base + ln]
    if fv[0x28:0x2C] != b'_FVH':
        print('%s @0x%X : no FV header (skip)' % (name, base))
        continue
    fv_len = struct.unpack("<Q", fv[0x20:0x28])[0]
    print('\n== %s @file 0x%X  FvLength=0x%X ==' % (name, base, fv_len))
    for off, size, ftype, g in walk(fv):
        abs_off = base + off
        region = 'A' if abs_off < PROTECT_LO else ('PROT' if abs_off < PROTECT_HI else 'B')
        print('  0x%08X  sz 0x%-8X type %02X  [%s]  %s' % (abs_off, size, ftype, region, g))
