import hashlib, shutil, os

SRC = r"C:\Users\Ghost\Desktop\bestproject\mods\original\System_BIOS.bin"
DST = r"C:\Users\Ghost\Desktop\bestproject\mods\v01_defaults\System_BIOS.bin"

BASE_SHA = "505d5f1971ba11f577a10fd16cb1bc52248be5c678e40e5049024ac367b5968e"
AMIV2_STORED = "6c8e1c15ef5f70d23710fccbebf71866e5acd73c34bcaa6a535bbe1509eb3098"
IBB_OFF, IBB_END = 0x700000, 0x900000

SETUP_DATA = 0x88
ABOVE4G = SETUP_DATA + 0x355   # 0x3DD
CSM     = SETUP_DATA + 0xCA2   # 0xD2A

def sha(b):
    return hashlib.sha256(b).hexdigest()

img = bytearray(open(SRC, "rb").read())
print("source sha:", sha(img))
assert sha(img) == BASE_SHA, "baseline mismatch!"

# sanity: guard regions match stored hashes BEFORE edit
assert sha(img[0x0E0000:0x462C00]) == AMIV2_STORED, "AMIv2 range hash mismatch (pre)"
ibb_pre = bytes(img[IBB_OFF:IBB_END])
print("pre-edit: AMIv2 range hash verified OK")

# record the edits
edits = []
for off, want_new, want_old in ((ABOVE4G, 0x01, 0x00), (CSM, 0x00, 0x01)):
    old = img[off]
    assert old == want_old, f"offset {off:#x}: expected 0x{want_old:02X}, found 0x{old:02X}"
    img[off] = want_new
    edits.append((off, old, want_new))

# verify guards remain intact AFTER edit
assert sha(img[0x0E0000:0x462C00]) == AMIV2_STORED, "AMIv2 range changed!"
assert bytes(img[IBB_OFF:IBB_END]) == ibb_pre, "IBB changed!"
print("post-edit: AMIv2 range hash OK + IBB region unchanged")

os.makedirs(os.path.dirname(DST), exist_ok=True)
open(DST, "wb").write(img)
print("new sha     :", sha(img))

# confirm in the written copy
chk = open(DST, "rb").read()
print("\nedits applied:")
for off, old, new in edits:
    print(f"  0x{off:06X}: 0x{old:02X} -> 0x{new:02X}  (now 0x{chk[off]:02X})")
print(f"  Above4G default (Setup+0x355) = 0x{chk[ABOVE4G]:02X}  (want 0x01)")
print(f"  CSM     default (Setup+0xCA2) = 0x{chk[CSM]:02X}  (want 0x00)")

# diff report
orig = open(SRC, "rb").read()
diff = [i for i in range(len(img)) if img[i] != orig[i]]
print("\nbyte diffs vs original:", [hex(d) for d in diff])
