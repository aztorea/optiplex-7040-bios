#!/usr/bin/env python
"""Extract the Setup module (899407D7) FFS body from a BIOS image's nested DXE FV.

Usage: python work\\scripts\\extract_setup_body.py <image> <out_body.bin>
"""
import sys
import struct
import lzma

FILE_GUID = struct.pack("<IHH", 0x9E21FD93, 0x9C72, 0x4C15) + bytes.fromhex("8C4BE77F1DB2D792")
SETUP_GUID = struct.pack("<IHH", 0x899407D7, 0x99FE, 0x43D8) + bytes.fromhex("9A2179EC328CAC21")


def u24(b, o):
    return b[o] | (b[o + 1] << 8) | (b[o + 2] << 16)


def main():
    img = open(sys.argv[1], "rb").read()
    foff = img.find(FILE_GUID)
    sec_off = foff + 24
    secsize = u24(img, sec_off)
    stream = bytearray(img[sec_off + 20 + 4: sec_off + secsize])
    stream[5:13] = b"\xFF" * 8
    dec = lzma.LZMADecompressor(format=lzma.FORMAT_ALONE).decompress(bytes(stream))
    g = dec.find(SETUP_GUID)
    assert g >= 0, "Setup module not found"
    size = u24(dec, g + 20)
    body = dec[g + 24: g + size]
    open(sys.argv[2], "wb").write(body)
    print("Setup FFS @dec 0x%X size=0x%X body=%d -> %s" % (g, size, len(body), sys.argv[2]))


if __name__ == "__main__":
    main()
