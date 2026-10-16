IMG = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin"
img = open(IMG, "rb").read()

# nested NVAR store = StdDefaults data: starts 0x77, length 5467
start, length = 0x77, 5467
end = start + length

pos = start
entries = []
while pos + 11 < end:
    if img[pos:pos + 4] != b"NVAR":
        if img[pos] == 0xFF:
            pos += 1
            continue
        print(f"stop: non-NVAR at 0x{pos:X}: {img[pos:pos+8].hex()}")
        break
    size = int.from_bytes(img[pos + 4:pos + 6], "little")
    flags = img[pos + 6:pos + 11]
    e = pos + 11
    ne = img.find(b"\x00", e, pos + size)
    name = img[e:ne].decode("ascii", "replace")
    dstart = ne + 1
    data = img[dstart:pos + size]
    entries.append((pos, size, name, flags, dstart, data))
    pos += size

print(f"nested store: parsed {len(entries)} entries (range 0x{start:X}..0x{end:X})\n")
print(f"{'offset':>8} {'size':>6} {'datalen':>7}  {'name':<26} flags5")
for pos, size, name, flags, dstart, data in entries:
    print(f"0x{pos:06X} {size:6} {len(data):7}  {name:<26} {flags.hex()}")

print("\ndistinct flags5:", {e[3].hex() for e in entries})

setup = [e for e in entries if e[2] == "Setup"]
for pos, size, name, flags, dstart, data in setup:
    print(f"\nSetup @0x{pos:X}: datalen={len(data)} data@0x{dstart:X}")
    print(f"  Above4G 0x355 = 0x{data[0x355]:02X}   CSM 0xCA2 = 0x{data[0xCA2]:02X}")
