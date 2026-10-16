import struct

PATH = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin"
data = open(PATH, "rb").read()

# Microcode blob reported by UEFITool at file offset 0x000E7940, size 0x0001AC00
base = 0x000E7940
end = base + 0x0001AC00
off = base
print(f"microcode blob: {hex(base)}..{hex(end)}")
n = 0
while off < end - 48:
    hv, rev, date, cpuid, csum, ldr, pflags, dsize, tsize = struct.unpack_from("<9I", data, off)
    if hv != 1:
        off += 4
        continue
    if tsize == 0 or tsize > 0x20000 or (off + tsize) > end:
        off += 4
        continue
    print(f"  #{n} cpuid=0x{cpuid:08X} rev=0x{rev:08X} date=0x{date:08X} ldr=0x{ldr:X} "
          f"size=0x{tsize:X} flags=0x{pflags:X} @ {hex(off)}")
    n += 1
    off += (tsize + 15) & ~15
print("total microcode records:", n)
