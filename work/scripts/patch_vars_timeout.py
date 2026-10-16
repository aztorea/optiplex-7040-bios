import shutil, os

VARS = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\vars.fd"
BAK  = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\vars_before_edit.fd"
data = bytearray(open(VARS, "rb").read())
shutil.copyfile(VARS, BAK)
print("backup ->", BAK)
off = 0x1D8
print("before:", data[off:off+2].hex())
assert data[off:off+2] == b"\x00\x00", "unexpected Timeout data"
data[off] = 0x05
data[off+1] = 0x00
open(VARS, "wb").write(data)
print("after :", data[off:off+2].hex())
print("vars.fd bytes changed:", sum(1 for a,b in zip(open(BAK,'rb').read(), data) if a!=b))
