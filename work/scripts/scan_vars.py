import struct

VARS = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\vars.fd"
data = open(VARS, "rb").read()
print(f"vars.fd size = {len(data)} (0x{len(data):X})")

def find_utf16(name):
    b = name.encode("utf-16-le")
    out = []
    i = 0
    while True:
        j = data.find(b, i)
        if j < 0:
            return out
        out.append(j)
        i = j + 1

for nm in ["BootOrder", "Timeout", "PlatformLang", "Boot0001", "Lang"]:
    hits = find_utf16(nm)
    print(f"{nm:14} utf16 @ {[hex(h) for h in hits]}")

# EDK2 variable store signature GUID { AA.. }? search for common store header patterns
# VARIABLE_STORE_HEADER.Signature = EFI_VARIABLE_STORE_SIGNATURE {0xAA?}. Try known: 
# Actually EDK2 uses { 0xAA, 0xAA, ... } no. Print first 0x40 bytes.
print("first 0x40:", data[:0x40].hex())
# look for a variable header: StartId(1)=0x55AA, State(1), Reserved(1), Attr(4), NameSize(4), DataSize(4), VendorGuid(16)
# Variable header starts with UINT16 StartId == 0x55AA (little endian 55 AA)
import re
pat = b"\x55\xaa"
hits = [m.start() for m in re.finditer(re.escape(pat), data)]
print(f"\n0x55AA (VAR header StartId) occurrences: {len(hits)}")
for h in hits[:6]:
    st = data[h:h+32].hex()
    x = h + 32
    print(f"  @0x{h:X}: {st}")
