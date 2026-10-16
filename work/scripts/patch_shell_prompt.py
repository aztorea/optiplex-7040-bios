import os

SRC = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\ovmf_code.fd.dump\0 48DB5E17-707C-472D-91CD-1613E7EF51B0\0 9E21FD93-9C72-4C15-8C4B-E77F1DB2D792\0 EE4E5898-3914-4259-9D6E-DC7BD79403CF\3 Volume image section\0 7CB8BDC9-F8EB-4F34-AAEA-3EE4AF6516A1\114 Shell\0 PE32 image section\body.bin"
OUT = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\shell_pe32_mod.bin"
data = bytearray(open(SRC, "rb").read())

off = 0x7F530
old = "Shell>".encode("utf-16-le")
new = "Pwned>".encode("utf-16-le")
print("at 0x%X before: %r" % (off, bytes(data[off:off+len(old)]).decode("utf-16-le")))
assert data[off:off+len(old)] == old, "prompt string not at expected offset"
data[off:off+len(new)] = new
print("after:         %r" % bytes(data[off:off+len(new)]).decode("utf-16-le"))
open(OUT, "wb").write(data)
print("wrote", OUT, len(data))
