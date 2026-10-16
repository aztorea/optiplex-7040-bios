import os, struct
from capstone import Cs, CS_ARCH_X86, CS_MODE_32

b = r'work\bios\System_BIOS.bin.dump\7 61C0F511-A691-4F54-974F-B9A42172CE53\13 B41956E1-7CA2-42DB-9562-168389F0F066'
d = open(os.path.join(b, '1 PE32 image section', 'body.bin'), 'rb').read()

e_lfanew = struct.unpack('<I', d[0x3c:0x40])[0]
foff = e_lfanew + 4
machine, nsec, ts, _, _, optsz, chars = struct.unpack('<HHIIIHH', d[foff:foff+20])
opt = foff + 20
imgbase = struct.unpack('<I', d[opt+28:opt+32])[0]
sec = opt + optsz
text = None
data = None
for i in range(nsec):
    s = d[sec+i*40:sec+i*40+40]
    nm = s[:8].rstrip(b'\x00').decode()
    vsz, va, rsz, rp = struct.unpack('<IIII', s[8:24])
    if nm == '.text':
        text = (va, rp, rsz)
    if nm == '.data':
        data = (va, rp, rsz)

print('ImageBase %08X  .text %s  .data %s' % (imgbase, txt() if False else (hex(tva:=text[0]), hex(text[3] if False else txt)) if False else (hex(0x240),), b and '', )) if False else None

# load sections into a flat image buffer indexed by RVA
img = bytearray(max(vsz for _, _, _, _ in [ (0,0,0,0)]) for _ in [])
# simpler: build image buffer covering up to end of .reloc
# recompute sections
secs = []
sec = (struct.unpack('<I', d[0x3c:0x40])[0]) + 4 + 20 + 0xe0
for i in range(3):
    s = d[sec+i*40:sec+i*40+40]
    nm = s[:8].rstrip(b'\x00').decode(); vsz, va, rsz, rp = struct.unpack('<IIII', s[8:24])
    sz = max(vsz, rsz)
    secs.append((nm, va, rp, rsz, vsz))
imgbase = struct.unpack('<I', d[0xc8+4+20+28:0xc8+4+20+32])[0]
img = bytearray(0x2000)
for nm, va, rp, rsz, vsz in secs:
    img[va:va+rsz] = d[rp:rp+rsz]

md = Cs(CS_ARCH_X86, CS_MODE_32)
md.detail = False
out = []
for ins in md.disasm(bytes(img[0x240:0x240+0x104f]), imgbase+0x240):
    out.append('%08X  %-24s %s %s' % (ins.address, ins.bytes.hex(), ins.mnemonic, ins.op_str))
open(r'work\scripts\bootguardpei_text.asm','w').write('\n'.join(out))
print('disassembled %d instructions -> work\\scripts\\bootguardpei_text.asm' % len(out))
print('ImageBase', hex(imgbase))
# print first 40 origin
for l in out[:40]:
    print(l)
