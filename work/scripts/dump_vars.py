VARS = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\vars.fd"
data = open(VARS, "rb").read()

def dump(start, end):
    for off in range(start, end, 16):
        chunk = data[off:off+16]
        hexs = " ".join(f"{b:02x}" for b in chunk)
        asc = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
        print(f"{off:06X}  {hexs:<48}  {asc}")

print("=== 0x40 .. 0x260 ===")
dump(0x40, 0x260)
print()
print("=== 0x15B0 .. 0x1630 (around Boot0001 @0x15cc) ===")
dump(0x15B0, 0x1630)
