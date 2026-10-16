import struct

PATH = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin"
data = open(PATH, "rb").read()

# GUID -> stored as: d1 d2 d3 d4 | d5 d6 | d7 d8 | d9 d10 | d11..d16 (mixed endian)
def guid_bytes(s):
    p = s.replace("-", "")
    b = bytes.fromhex(p)
    return b[3::-1] + b[5:3:-1] + b[7:5:-1] + b[8:]  # Data1 LE, Data2 LE, Data3 LE

guids = {
    "vol5 4F1C52D3 (main BIOS)": "4F1C52D3-D824-4D2A-A2F0-EC40C23C5916",
    "vol4 FD44D4FE (defaults)":  "FD44D4FE-239B-4C57-B96D-E47E066A50A3",
    "vol7 61C0F511 (IBB/PEI)":   "61C0F511-A691-4F54-974F-B9A42172CE53",
    "nested 5C60F367 (DXE)":     "5C60F367-A505-419A-859E-2A4FF6CA6FE5",
    "nested BDB6C5ED":           "BDB6C5ED-6BF3-4909-837C-353F6DCBB6A2",
    "vol0 8C8CE578 (NVAR)":      "8C8CE578-8A3D-4F1C-9935-896185C32DD3",
    "vol3 E34AEDB0":             "E34AEDB0-BB97-49BC-B139-1E419B3560E2",
    "vol6 AFDD39F1":             "AFDD39F1-19D7-4501-A730-CE5A27E1154B",
}

PROT_LO, PROT_HI = 0x0E0000, 0x0E0000 + 0x382C00
IBB_LO, IBB_HI = 0x700000, 0x900000
print(f"protected range = 0x{PROT_LO:X}..0x{PROT_HI:X}")
print(f"IBB             = 0x{IBB_LO:X}..0x{IBB_HI:X}\n")

for name, g in guids.items():
    pat = guid_bytes(g)
    idx = 0
    locs = []
    while True:
        i = data.find(pat, idx)
        if i < 0:
            break
        locs.append(i)
        idx = i + 1
    for i in locs:
        role = "PROTECTED" if PROT_LO <= i < PROT_HI else ("IBB" if IBB_LO <= i < IBB_HI else "editable")
        print(f"{name:26} @ 0x{i:07X}  -> {role}")
    if not locs:
        print(f"{name:26} NOT FOUND")
