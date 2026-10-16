BODY = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\ovmf_code.fd.dump\0 48DB5E17-707C-472D-91CD-1613E7EF51B0\0 9E21FD93-9C72-4C15-8C4B-E77F1DB2D792\0 EE4E5898-3914-4259-9D6E-DC7BD79403CF\3 Volume image section\0 7CB8BDC9-F8EB-4F34-AAEA-3EE4AF6516A1\114 Shell\0 PE32 image section\body.bin"
data = open(BODY, "rb").read()

def utf16_at(off):
    # read null-terminated utf-16le
    out = []
    i = off
    while i + 1 < len(data):
        ch = data[i] | (data[i+1] << 8)
        if ch == 0:
            break
        if ch < 32 or ch > 0x2FFF:
            return None
        out.append(chr(ch))
        i += 2
    return "".join(out)

# scan region 0x7d700..0x7f600 for utf-16 strings
start, end = 0x7d700, 0x7f620
print("=== UTF-16 strings in 0x7d700..0x7f620 ===")
i = start
while i < end:
    # try to detect start of a string: preceding 2 bytes zero or non-ascii
    s = utf16_at(i)
    if s and len(s) >= 3:
        try:
            line = f"0x{i:06X}: " + ascii(s)
        except Exception:
            line = f"0x{i:06X}: <unprintable>"
        print(line)
        i += len(s)*2 + 2
    else:
        i += 2
