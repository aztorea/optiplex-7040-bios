BODY = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\ovmf_code.fd.dump\0 48DB5E17-707C-472D-91CD-1613E7EF51B0\0 9E21FD93-9C72-4C15-8C4B-E77F1DB2D792\0 EE4E5898-3914-4259-9D6E-DC7BD79403CF\3 Volume image section\0 7CB8BDC9-F8EB-4F34-AAEA-3EE4AF6516A1\114 Shell\0 PE32 image section\body.bin"
data = open(BODY, "rb").read()
print("body size", len(data), "MZ?", data[:2])
for s in [b"UEFI Interactive Shell", b"UEFI v", b"Shell>", b"startup.nsh",
          b"EDK II", b"Copyright", b"2.2", b"2.70"]:
    offs = []
    i = 0
    while True:
        j = data.find(s, i)
        if j < 0: break
        offs.append(j); i = j+1
    print(f"{s!r:26} {len(offs):3} {[hex(o) for o in offs[:6]]}")
