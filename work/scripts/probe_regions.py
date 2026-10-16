import struct

img = open(r'work\bios\System_BIOS.bin', 'rb').read()

print('--- vol5 free-space boundary (0x462890..0x462C10) ---')
seg = img[0x462890:0x462C10]
# summarize runs
i = 0
while i < len(seg):
    b = seg[i]
    j = i
    while j < len(seg) and seg[j] == b:
        j += 1
    print('  0x%06X  x%3d  byte %02X' % (0x462890 + i, j - i, b))
    i = j

print()
print('--- vol6 header @0x680000 ---')
h = img[0x680000:0x680100]
for o in range(0, 0x100, 16):
    print('  0x%06X  %s  %s' % (0x680000 + o, h[o:o+16].hex(' '), ''.join(chr(c) if 32 <= c < 127 else '.' for c in h[o:o+16])))

print()
print('vol6 header lens: HeaderLength=0x%X ExtHeaderOffset=0x%X' % (
    struct.unpack('<H', img[0x680030:0x680032])[0],
    struct.unpack('<H', img[0x680034:0x680036])[0]))
print('vol6 FvLength=0x%X' % struct.unpack('<Q', img[0x680020:0x680028])[0])
print('vol6 FvHdr2 @0x%X sig=%s' % (0x680028, img[0x680028:0x68002C]))

# robust walk of vol6: scan for FFS headers by state byte 0xF8..0xFF range
print()
print('--- vol6: scan for FF-runs (free space) ---')
base = 0x680000
end = 0x700000
p = base
while p < end:
    if img[p] == 0xFF:
        j = p
        while j < end and img[j] == 0xFF:
            j += 1
        if j - p >= 16:
            print('  free 0x%06X..0x%06X (%d bytes)' % (p, j - 1, j - p))
            p = j
            continue
    p += 1
