IMG = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin"
BODY = (r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin.dump"
        r"\4 FD44D4FE-239B-4C57-B96D-E47E066A50A3\11 NVRAM external defaults"
        r"\0 EE4E5898-3914-4259-9D6E-DC7BD79403CF\0 Raw section"
        r"\0 StdDefaults\0 Setup\body.bin")

img = open(IMG, "rb").read()
body = open(BODY, "rb").read()

f = img.find(body)
print("full-body find:", hex(f) if f >= 0 else "NOT FOUND")

for off in (0x340, 0xC90, 0x100):
    w = body[off:off + 64]
    j = img.find(w, 0xD0000, 0xE0000)
    if j >= 0:
        base = j - off
        print(f"window@0x{off:X} -> body base = 0x{base:X}")
        print(f"  Above4G img[0x{base+0x355:X}]=0x{img[base+0x355]:02X} (body 0x{body[0x355]:02X})")
        print(f"  CSM     img[0x{base+0xCA2:X}]=0x{img[base+0xCA2]:02X} (body 0x{body[0xCA2]:02X})")
        break
    else:
        print(f"window@0x{off:X} -> NOT FOUND in vol4")
