import hashlib

PATH = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin"
data = open(PATH, "rb").read()

target = "6C8E1C15EF5F70D23710FCCBEBF71866E5ACD73C34BCAA6A535BBE1509EB3098"

# Reported: Address FF7E0000h, Size 382C00h. BIOS region base = 0xFF700000.
base_file = 0xFF7E0000 - 0xFF700000
size = 0x382C00
cand = {
    "asm-reported FF7E0000+0x382C00": (base_file, size),
    "VM base 0x0E0000+0x382C00": (0x0E0000, size),
    "whole BIOS region 9MiB": (0, len(data)),
}
for label, (off, ln) in cand.items():
    if off < 0 or off + ln > len(data):
        print(f"{label:42} OUT OF RANGE off=0x{off:X} len=0x{ln:X}")
        continue
    h = hashlib.sha256(data[off:off + ln]).hexdigest().upper()
    print(f"{label:42} off=0x{off:X} len=0x{ln:X} sha256={h} match={h==target}")

# Also try hashing the IBB segments (BPM) to confirm
segs = [(0xFFE00000, 0x170000), (0xFFF78000, 0x80), (0xFFF79080, 0x80), (0xFFF7A100, 0x85F00)]
h = hashlib.sha256()
for a, s in segs:
    o = a - 0xFF700000
    h.update(data[o:o + s])
print("IBB segments SHA256:", h.hexdigest().upper())
print("BPM expected IBB   : F41A1C2439602D17C6737325B06B47963CD15103EDC9EFDBFB730488FEEA3420")
