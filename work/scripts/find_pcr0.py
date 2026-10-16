import hashlib, os

d = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin.dump\5 4F1C52D3-D824-4D2A-A2F0-EC40C23C5916\2 9E21FD93-9C72-4C15-8C4B-E77F1DB2D792\0 EE4E5898-3914-4259-9D6E-DC7BD79403CF"
target = "3a5c91feeaaa9fa292e58cf8c1f5b3c400697b345c17d30cfce5521f6ec43e92"

cands = [d]
for root, dirs, files in os.walk(d):
    for f in files:
        if f == "body.bin":
            cands.append(os.path.join(root, f))

for p in cands:
    fp = os.path.join(p, "body.bin") if os.path.isdir(p) else p
    if not os.path.isfile(fp):
        continue
    b = open(fp, "rb").read()
    h = hashlib.sha256(b).hexdigest()
    rel = os.path.relpath(fp, os.path.dirname(d))
    tag = "  <== PCR0 MATCH" if h == target else ""
    if len(b) > 400000 or "Volume image section" in fp or fp == os.path.join(d, "body.bin"):
        print(f"{len(b):>9}  {h[:24]}  {rel[:70]}{tag}")
