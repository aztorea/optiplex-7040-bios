IMG = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin"
BODY = (r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin.dump"
        r"\4 FD44D4FE-239B-4C57-B96D-E47E066A50A3\11 NVRAM external defaults"
        r"\0 EE4E5898-3914-4259-9D6E-DC7BD79403CF\0 Raw section"
        r"\0 StdDefaults\0 Setup\body.bin")

img = open(IMG, "rb").read()
body = open(BODY, "rb").read()

print("== all occurrences of full 4928B body ==")
idx, hits = 0, []
while True:
    i = img.find(body, idx)
    if i < 0:
        break
    hits.append(i)
    idx = i + 1
for h in hits:
    zone = "vol0" if h < 0x40000 else ("vol4" if 0xD0000 <= h < 0xE0000 else "?")
    print(f"  0x{h:06X} ({zone})")

print("\n== structure around 0x48 (vol0 first FFS) ==")
b = img[0x48:0x48 + 0x50]
for off in range(0, 0x50, 16):
    hexs = " ".join(f"{x:02X}" for x in b[off:off+16])
    asc = "".join(chr(x) if 32 <= x < 127 else "." for x in b[off:off+16])
    print(f"  0x{0x48+off:05X}  {hexs}  {asc}")

print("\n== body first 32B vs img@0x88 ==")
print("  body :", " ".join(f"{x:02X}" for x in body[:32]))
print("  img  :", " ".join(f"{x:02X}" for x in img[0x88:0x88+32]))
print("  body[0x340..0x360]:", " ".join(f"{x:02X}" for x in body[0x340:0x360]))
print("  body[0xC90..0xCB0]:", " ".join(f"{x:02X}" for x in body[0xC90:0xCB0]))
