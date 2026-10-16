A = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\vars_before_edit.fd"
B = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\vars.fd"
a = open(A, "rb").read()
b = open(B, "rb").read()
print("A size", len(a), "B size", len(b))
diffs = [i for i in range(min(len(a), len(b))) if a[i] != b[i]]
print("total byte diffs:", len(diffs))
print("0x1D8 in B:", b[0x1D8:0x1DA].hex(), " (we wrote 05 00)")
for i in diffs[:40]:
    print(f"  0x{i:X}: A={a[i]:02x} B={b[i]:02x}")
# check store header signature still present
sig = bytes.fromhex("782cf3aa7b949a43a1802e144ec37792")
print("store sig present in B:", b.find(sig))
print("healthy state byte (0x5C):", hex(b[0x5C]), hex(b[0x5D]))
