import struct
IMG = r'work\bios\System_BIOS.bin'
d = open(IMG, 'rb').read()
n = len(d)
base = 0x100000000 - n  # top-aligned mapping
print('image size 0x%X  base addr 0x%X' % (n, base))

fit_off = None
# strategy 1: architectural pointer at end-0x40
p = n - 0x40
addr = struct.unpack('<I', d[p:p+4])[0]
cand = addr - base
print('ptr@end-0x40 -> %08X (file 0x%X)' % (addr, cand))
if 0 <= cand < n and d[cand:cand+8] == b'_FIT_   ':
    fit_off = cand
if fit_off is None:
    fit_off = d.rfind(b'_FIT_   ')
print('FIT file offset 0x%X' % fit_off)

num = d[fit_off + 10]
print('FIT hdr bytes %s  num_entries(off+10)=%d' % (d[fit_off:fit_off+16].hex(' '), num))
names = {0x00:'HEADER',0x01:'MICROCODE',0x02:'STARTUP_ACM',0x03:'DIAG_ACM',0x07:'BOOT_POLICY/IBB',
         0x0A:'TXTPOLICY',0x0B:'KMSM/KEYMANIFEST',0x0C:'TPM',0x10:'BOOT_POLICY_MANIFEST',0x2F:'TXT'}
for i in range(0, min(num + 2, 12)):
    eo = fit_off + i * 16
    if eo + 16 > n:
        break
    a = int.from_bytes(d[eo:eo+8], 'little')
    sz16 = int.from_bytes(d[eo+8:eo+11], 'little')
    ver = int.from_bytes(d[eo+13:eo+15], 'little')
    t = d[eo+15]
    chk = t >> 7
    t &= 0x7F
    fo = a - base
    print('  e%-2d %-22s addr %016X  size 0x%-7X file 0x%-7X ver 0x%04X chk %d  tstr=%s' % (
        i, names.get(t, 'type0x%X' % t), a, sz16*16, fo, ver, chk, repr(d[eo:eo+8])))
