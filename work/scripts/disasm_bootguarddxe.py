import os, struct
from capstone import Cs, CS_ARCH_X86, CS_MODE_64

D = r'work\bios\System_BIOS.bin.dump\5 4F1C52D3-D824-4D2A-A2F0-EC40C23C5916\2 9E21FD93-9C72-4C15-8C4B-E77F1DB2D792\0 EE4E5898-3914-4259-9D6E-DC7BD79403CF\1 Volume image section\0 5C60F367-A505-419A-859E-2A4FF6CA6FE5\84 1DB43EC9-DF5F-4CF5-AAF0-0E85DB4E149A\1 PE32 image section'
d = open(os.path.join(D, 'body.bin'), 'rb').read()

e = struct.unpack('<I', d[0x3c:0x40])[0]
foff = e + 4
machine, nsec, _, _, _, optsz, _ = struct.unpack('<HHIIIHH', d[foff:foff+20])
opt = foff + 20
imgbase = struct.unpack('<Q', d[opt+24:opt+32])[0]
entry = struct.unpack('<I', d[opt+16:opt+20])[0]
sec = opt + optsz
secs = []
for i in range(nsec):
    s = d[sec+i*40:sec+i*40+40]
    nm = s[:8].rstrip(b'\x00').decode()
    vsz, va, rsz, rp = struct.unpack('<IIII', s[8:24])
    secs.append((nm, va, rp, rsz, vsz))
    print('%-8s VA %08X VSZ %08X RAW %08X RSZ %08X' % (nm, va, vsz, rp, rsz))

hi = max(va + max(vsz, rsz) for nm, va, rp, rsz, vsz in secs)
img = bytearray(hi)
for nm, va, rp, rsz, vsz in secs:
    img[va:va+rsz] = d[rp:rp+rsz]

print('ImageBase %X  Entry %X  sections=%d  machine=%04X' % (imgbase, entry, nsec, machine))

md = Cs(CS_ARCH_X86, CS_MODE_64)
out = []
for ins in md.disasm(bytes(img[entry:hi]), imgbase + entry):
    out.append('%08X  %-22s %s %s' % (ins.address, ins.bytes.hex(), ins.mnemonic, ins.op_str))
open(r'work\scripts\bootguarddxe_text.asm', 'w').write('\n'.join(out))
print('disassembled %d instructions -> work\\scripts\\bootguarddxe_text.asm' % len(out))
