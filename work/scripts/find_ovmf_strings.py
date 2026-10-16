FD = r"C:\Users\Ghost\Desktop\bestproject\tools\qemu\share\edk2-x86_64-code.fd"
data = open(FD, "rb").read()
print("code.fd size", len(data))
for s in [b"EDK II", b"UEFI Interactive Shell", b"Press ESC", b"EFI Internal Shell",
          b"UEFI v2.70", b"startup.nsh", b"Shell>", b"iPXE", b"ReBAR"]:
    offs = []
    i = 0
    while True:
        j = data.find(s, i)
        if j < 0:
            break
        offs.append(j)
        i = j + 1
    print(f"{s!r:28} {len(offs):3}  {[hex(o) for o in offs[:8]]}")
