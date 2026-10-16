IMG = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin"
img = open(IMG, "rb").read()

# vol0 NVAR store: FFS RAW file at 0x48 (hdr 0x18) -> entries start at 0x60
pos = 0x60
entries = []
while pos + 11 < 0x40000:
    if img[pos:pos + 4] != b"NVAR":
        # skip padding (FF)
        if img[pos] == 0xFF:
            pos += 1
            continue
        break
    size = int.from_bytes(img[pos + 4:pos + 6], "little")
    flags = img[pos + 6:pos + 11]           # 5 bytes after Size
    e = pos + 11
    name_end = img.find(b"\x00", e, pos + size)
    name = img[e:name_end].decode("ascii", "replace")
    dstart = name_end + 1
    data = img[dstart:pos + size]
    entries.append((pos, size, name, flags, dstart, data))
    if size < 11 or pos + size <= pos:
        break
    pos += size

print(f"parsed {len(entries)} NVAR entries in vol0\n")
print(f"{'offset':>8} {'size':>6} {'name':<28} {'flags5':<14} data[0x355]/[0xCA2]")
for pos, size, name, flags, dstart, data in entries:
    fl = flags.hex()
    extra = ""
    if len(data) > 0xCA2:
        extra = f"  0x355=0x{data[0x355]:02X} 0xCA2=0x{data[0xCA2]:02X}"
    print(f"0x{pos:06X} {size:6} {name:<28} {fl:<14}{extra}")

print("\n== are the 5 flag bytes constant across entries? ==")
uniq = {e[3].hex() for e in entries}
print("distinct flag5 patterns:", uniq if len(uniq) <= 8 else f"{len(uniq)} distinct (checksum-like?)")

# look specifically for a live 'Setup' entry (size ~4945) and compare its data to defaults
setup = [e for e in entries if e[2] == "Setup"]
print(f"\nSetup-named entries: {len(setup)}")
for pos, size, name, flags, dstart, data in setup:
    print(f"  @{pos:#x} size={size} datalen={len(data)} 0x355=0x{data[0x355]:02X} 0xCA2=0x{data[0xCA2]:02X}")
