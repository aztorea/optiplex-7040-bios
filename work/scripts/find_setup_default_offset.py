import os

IMG = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin"
BODY = (r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin.dump"
        r"\4 FD44D4FE-239B-4C57-B96D-E47E066A50A3\11 NVRAM external defaults"
        r"\0 EE4E5898-3914-4259-9D6E-DC7BD79403CF\0 Raw section"
        r"\0 StdDefaults\0 Setup\body.bin")

img = open(IMG, "rb").read()
body = open(BODY, "rb").read()
print(f"body len = {len(body)} (0x{len(body):X})")

# find the body verbatim in the image
needle = body[:128]
i = img.find(needle)
print("body start in image:", hex(i) if i >= 0 else "NOT FOUND (128B prefix)")
if i < 0:
    # try progressively shorter prefixes
    for n in (64, 32, 16):
        i = img.find(body[:n])
        print(f"  prefix {n} -> {hex(i) if i>=0 else 'NOT FOUND'}")
        if i >= 0:
            break

if i >= 0:
    end = i + len(body)
    print(f"body range = 0x{i:X}..0x{end:X}")
    # key offsets
    for off, name, exp in [(0x355, "Above4G", 0), (0xCA2, "CSM", 1)]:
        cur = body[off]
        print(f"  body[0x{off:X}] {name}: current=0x{cur:02X} target={'0x01' if name=='Above4G' else '0x00'}")
    print("  image byte check (same):", all(img[i+o] == body[o] for o in (0x355, 0xCA2)))

# locate enclosing FFS file: scan back up to 0x1000 for an 8-aligned FFS header
# FFS header: GUID(16) + IntegrityCheck(2) + Type(1) + Attributes(1) + Size(3) + State(1) = 24
print("\n-- scanning back for FFS header --")
for back in range(i, max(0, i - 0x4000), -1):
    # Type must be one of known FFS types (raw=0x01, freeform=0x02, etc.)
    t = img[back + 18]
    attrs = img[back + 19]
    if t in (0x01, 0x02, 0x03, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0xF0) and img[back + 23] in (0xF8, 0xF0, 0x07, 0x06, 0x05, 0x04):
        size = int.from_bytes(img[back + 20:back + 23], "little")
        if 0x40 < size < 0x200000:
            print(f"  candidate FFS @ 0x{back:X} type=0x{t:02X} attrs=0x{attrs:02X} "
                  f"size=0x{size:X} state=0x{img[back+23]:02X} headerInteg=0x{img[back+16]:02X}{img[back+17]:02X}")
            if back < i < back + size:
                print(f"  -> contains our body (0x{i:X} in 0x{back:X}..0x{back+size:X})")
            break
