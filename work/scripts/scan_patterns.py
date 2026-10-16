import sys

PATH = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin"
data = open(PATH, "rb").read()


def find_all(pat):
    out = []
    start = 0
    while True:
        i = data.find(pat, start)
        if i < 0:
            break
        out.append(i)
        start = i + 1
    return out


def report(pat, label):
    hits = find_all(pat)
    first = hex(hits[0]) if hits else "NONE"
    print(f"{label:34} count={len(hits):<4} first={first}  at={[hex(h) for h in hits[:6]]}")


ucodes = {
    "Skylake  0506E3": bytes.fromhex("E3060500") + b"\x01\x00\x00\x00",
    "KabyLake 0906E9": bytes.fromhex("E9060900") + b"\x01\x00\x00\x00",
    "CoffeeLk 0906EA": bytes.fromhex("EA060900") + b"\x01\x00\x00\x00",
    "CascadeL 0506E5": bytes.fromhex("E5060500") + b"\x01\x00\x00\x00",
}
for k, v in ucodes.items():
    report(v, "ucode " + k)

for s in [b"ReSize", b"Re-Size", b"Resizable", b"Above 4G", b"ResizeBAR",
          b"CFG Lock", b"BIOS Lock", b"Boot Guard", b"BIOS Guard",
          b"Intel(R) Speed Shift", b"SR-IOV", b"VT-d"]:
    report(s, s.decode(errors="replace"))

# AMI / Dell build id strings
for s in [b"$IBIOSI$", b"Aptio", b"Intel(R) PCH", b"RC Version", b"MRCD"]:
    report(s, s.decode())
