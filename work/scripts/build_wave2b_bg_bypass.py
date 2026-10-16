#!/usr/bin/env python
"""Wave 2b builder: W2 (ReBarDxe insert) PLUS neutralization of the AMI DXE
integrity enforcer `BootGuardDxe` (GUID 1DB43EC9-...).

Rationale (see WAVE_PLAN.md 4.1): the Intel ACM hardware-verifies only the IBB
(vol7). The DXE FV hash is an AMI *software* guard; `BootGuardPei` only sets a
flag and the only actor that halts is `BootGuardDxe`, a DXE driver in vol5 (not
in the IBB). Patching its worker (RVA 0x1070) to `xor eax,eax; ret` prevents it
from arming its shutdown event, so a modified (hash-stale) DXE region boots while
the IBB/ACM chain still verifies. Offline sandbox build only - never flashes.

Usage: python work\\scripts\\build_wave2b_bg_bypass.py
"""
import os
import struct
import lzma

IMG = os.path.join("work", "bios", "System_BIOS.bin")
OUTDIR = os.path.join("mods", "v02b_rebar_bgbypass")
OUT = os.path.join(OUTDIR, "System_BIOS.bin")
FFS = os.path.join("tools", "ReBARUEFI_0.3", "ReBarDxe.ffs")

REBAR_GUID = struct.pack("<IHH", 0xA8EE1777, 0xA4F5, 0x4345) + bytes.fromhex("9DA413742084D31E")
FILE_GUID = struct.pack("<IHH", 0x9E21FD93, 0x9C72, 0x4C15) + bytes.fromhex("8C4BE77F1DB2D792")
FV_GUID = struct.pack("<IHH", 0x5C60F367, 0xA505, 0x419A) + bytes.fromhex("859E2A4FF6CA6FE5")
BG_GUID = struct.pack("<IHH", 0x1DB43EC9, 0xDF5F, 0x4CF5) + bytes.fromhex("AAF00E85DB4E149A")

BG_PATCH_RVA = 0x1070
BG_PATCH_OLD = bytes.fromhex("4053 48")          # push rbx; (sub rsp,..)
BG_PATCH_NEW = bytes.fromhex("31c0 c3")          # xor eax,eax; ret


def u24(b, o):
    return b[o] | (b[o + 1] << 8) | (b[o + 2] << 16)


def find_pe_rva(dec, target_rva):
    """Return the absolute dec offset of `target_rva` inside BootGuardDxe's PE32."""
    g = dec.find(BG_GUID)
    assert g >= 0, "BootGuardDxe GUID not found"
    size = u24(dec, g + 20)
    p = g + 24
    end = g + size
    while p + 4 <= dec.__len__():
        ssz = u24(dec, p)
        stype = dec[p + 3]
        if stype == 0x10:
            pe = p + 4
            e_lfanew = struct.unpack("<I", dec[pe + 0x3C:pe + 0x40])[0]
            coff = pe + e_lfanew + 4
            nsec = struct.unpack("<H", dec[coff + 2:coff + 4])[0]
            optsize = struct.unpack("<H", dec[coff + 16:coff + 18])[0]
            optoff = coff + 20
            sectab = opttoff = optoff + optsize
            for s in range(nsec):
                so = sectab + s * 40
                vsize = struct.unpack("<I", dec[so + 8:so + 12])[0]
                vaddr = struct.unpack("<I", dec[so + 12:so + 16])[0]
                rsize = struct.unpack("<I", dec[so + 16:so + 20])[0]
                raw = struct.unpack("<I", dec[so + 20:so + 24])[0]
                if vaddr <= target_rva < vaddr + max(vsize, rsize):
                    return pe + raw + (target_rva - vaddr)
        p = (p + u24(dec, p) + 3) & ~3
    raise SystemExit("RVA 0x%X not found in BootGuardDxe" % target_rva)


def main():
    if os.path.exists(OUT):
        os.remove(OUT)
    os.makedirs(OUTDIR, exist_ok=True)

    data = bytearray(open(IMG, "rb").read())

    foff = data.find(FILE_GUID)
    assert foff > 0, "file 9E21FD93 not found"
    filesize = u24(data, foff + 20)
    sec_off = foff + 24
    secsize = u24(data, sec_off)
    comp_off = sec_off + 20
    prefix = bytes(data[comp_off:comp_off + 4])
    stream = bytes(data[comp_off + 4: sec_off + secsize])
    print("file 9E21FD93 @0x%X size=0x%X section=0x%X prefix=%s"
          % (foff, filesize, secsize, prefix.hex()))

    dec = bytearray(lzma.decompress(stream, format=lzma.FORMAT_ALONE))
    print("decompressed FV stream: %d (0x%X)" % (len(dec), len(dec)))

    # ---- (1) neutralize BootGuardDxe worker ----
    patch_off = find_pe_rva(dec, BG_PATCH_RVA)
    cur = bytes(dec[patch_off:patch_off + len(BG_PATCH_OLD)])
    print("BootGuardDxe RVA 0x%X @ dec 0x%X : %s" % (BG_PATCH_RVA, patch_off, cur.hex()))
    assert cur == BG_PATCH_OLD, "unexpected bytes at patch site"
    dec[patch_off:patch_off + len(BG_PATCH_NEW)] = BG_PATCH_NEW
    print("patched -> %s (xor eax,eax; ret)" % BG_PATCH_NEW.hex())

    # ---- (2) insert ReBarDxe.ffs into FV free space ----
    fsg = struct.pack("<IHH", 0x8C8CE578, 0x8A3D, 0x4F1C) + bytes.fromhex("9935896185C32DD3")
    fv_start = dec.find(fsg) - 0x10
    fv_len = struct.unpack("<I", dec[fv_start + 0x20:fv_start + 0x24])[0]
    fv_end = fv_start + fv_len
    p = fv_end
    while p > fv_start and dec[p - 1] == 0xFF:
        p -= 1
    free_off = p - fv_start
    free_size = fv_end - p
    print("FV @0x%X len=0x%X ; free @0x%X size=0x%X" % (fv_start, fv_len, free_off, free_size))
    assert free_off == 0x84B5D0, "unexpected free-space offset 0x%X" % free_off

    rebar = open(FFS, "rb").read()
    assert rebar[0:16] == REBAR_GUID, "ReBarDxe.ffs GUID mismatch"
    assert u24(rebar, 20) == len(rebar), "rebar size field mismatch"
    assert dec.find(REBAR_GUID) < 0, "ReBarDxe already present"
    assert len(rebar) <= free_size, "not enough free space"
    abs_off = fv_start + free_off
    dec[abs_off:abs_off + len(rebar)] = rebar
    dec[abs_off + len(rebar): abs_off + free_size] = b"\xFF" * (free_size - len(rebar))
    print("inserted ReBarDxe (%d B); remaining free = %d" % (len(rebar), free_size - len(rebar)))

    # ---- (3) recompress + write ----
    filters = [{"id": lzma.FILTER_LZMA1, "dict_size": 0x1000000, "lc": 3, "lp": 0, "pb": 2}]
    new_stream = bytearray(lzma.compress(bytes(dec), format=lzma.FORMAT_ALONE, filters=filters))
    assert lzma.decompress(bytes(new_stream), format=lzma.FORMAT_ALONE) == bytes(dec)
    new_stream[5:13] = struct.pack("<Q", len(dec))
    new_stream = bytes(new_stream)
    old_stream_len = secsize - 20 - 4
    print("recompressed %d vs old region %d (delta %+d)"
          % (len(new_stream), old_stream_len, len(new_stream) - old_stream_len))
    if len(new_stream) > old_stream_len:
        raise SystemExit("recompressed stream larger than original - would need container rebuild")
    padded = new_stream + b"\x00" * (old_stream_len - len(new_stream))

    data[comp_off + 4: sec_off + secsize] = padded
    assert u24(data, sec_off) == secsize
    assert u24(data, foff + 20) == filesize
    open(OUT, "wb").write(data)
    print("wrote", OUT, len(data), "bytes")

    # ---- self-verify ----
    out = bytearray(open(OUT, "rb").read())
    ofoff = out.find(FILE_GUID)
    osecsize = u24(out, ofoff + 24)
    ostream = bytearray(out[ofoff + 48: ofoff + 24 + osecsize])
    ostream[5:13] = b"\xFF" * 8
    odec = lzma.LZMADecompressor(format=lzma.FORMAT_ALONE)
    out_dec = odec.decompress(bytes(ostream))
    assert odec.eof, "end-of-stream marker not reached"
    ro = out_dec.find(REBAR_GUID)
    po = find_pe_rva(bytearray(out_dec), BG_PATCH_RVA)
    pv = bytes(out_dec[po:po + len(BG_PATCH_NEW)])
    print("SELF-VERIFY: ReBarDxe @dec 0x%X ; patch @dec 0x%X = %s" % (ro, po, pv.hex()))
    assert ro > 0 and pv == BG_PATCH_NEW
    print("OK")


if __name__ == "__main__":
    main()
