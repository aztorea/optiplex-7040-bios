#!/usr/bin/env python
"""Wave 5 builder (force-enable variant): W2b base + flip EVERY constant-true
condition guard in the Setup IFR.

Covers all three guard opcodes with a constant `True` operand:
  0A 82 46 02  SuppressIf -> False   (hide -> show)          x19
  19 82 46 02  GrayOutIf  -> False   (gray -> selectable)    x1
  1E 82 46 02  DisableIf  -> False   (disable -> enable)     x1
= 21 flips.  True=0x46, False=0x47 (same length).

This is the most aggressive unlock (v04 + the 2 always-gray/disable items).
Sandbox build only - never flashes.

Usage: python work\\scripts\\build_wave5_force_enable.py
"""
import os
import struct
import lzma

IMG = os.path.join("work", "bios", "System_BIOS.bin")
OUTDIR = os.path.join("mods", "v05_force_enable")
OUT = os.path.join(OUTDIR, "System_BIOS.bin")
FFS = os.path.join("tools", "ReBARUEFI_0.3", "ReBarDxe.ffs")

REBAR_GUID = struct.pack("<IHH", 0xA8EE1777, 0xA4F5, 0x4345) + bytes.fromhex("9DA413742084D31E")
FILE_GUID = struct.pack("<IHH", 0x9E21FD93, 0x9C72, 0x4C15) + bytes.fromhex("8C4BE77F1DB2D792")
FS_GUID = struct.pack("<IHH", 0x8C8CE578, 0x8A3D, 0x4F1C) + bytes.fromhex("9935896185C32DD3")
BG_GUID = struct.pack("<IHH", 0x1DB43EC9, 0xDF5F, 0x4CF5) + bytes.fromhex("AAF00E85DB4E149A")

BG_PATCH_RVA = 0x1070
BG_PATCH_OLD = bytes.fromhex("4053 48")
BG_PATCH_NEW = bytes.fromhex("31c0 c3")

# (opcode, label) -> guard is <opcode> 82 46 02
GUARDS = [(0x0A, "SuppressIf"), (0x19, "GrayOutIf"), (0x1E, "DisableIf")]
TRUE_B, FALSE_B = 0x46, 0x47


def u24(b, o):
    return b[o] | (b[o + 1] << 8) | (b[o + 2] << 16)


def find_pe_rva(dec, target_rva):
    g = dec.find(BG_GUID)
    assert g >= 0, "BootGuardDxe GUID not found"
    p = g + 24
    while p + 4 <= len(dec):
        if dec[p + 3] == 0x10:
            pe = p + 4
            e_lfanew = struct.unpack("<I", dec[pe + 0x3C:pe + 0x40])[0]
            coff = pe + e_lfanew + 4
            nsec = struct.unpack("<H", dec[coff + 2:coff + 4])[0]
            optsize = struct.unpack("<H", dec[coff + 16:coff + 18])[0]
            sectab = coff + 20 + optsize
            for s in range(nsec):
                so = sectab + s * 40
                vsize = struct.unpack("<I", dec[so + 8:so + 12])[0]
                vaddr = struct.unpack("<I", dec[so + 12:so + 16])[0]
                rsize = struct.unpack("<I", dec[so + 16:so + 20])[0]
                raw = struct.unpack("<I", dec[so + 20:so + 24])[0]
                if vaddr <= target_rva < vaddr + max(vsize, rsize):
                    return pe + raw + (target_rva - vaddr)
        p = (p + u24(dec, p) + 3) & ~3
    raise SystemExit("RVA 0x%X not found" % target_rva)


def flip_all(dec):
    hits = {}
    for op, name in GUARDS:
        pat = bytes([op, 0x82, TRUE_B, 0x02])
        o = 0
        n = 0
        while True:
            i = dec.find(pat, o)
            if i < 0:
                break
            o = i + 1
            dec[i + 2] = FALSE_B
            n += 1
        hits[name] = n
    return hits


def main():
    if os.path.exists(OUT):
        os.remove(OUT)
    os.makedirs(OUTDIR, exist_ok=True)

    data = bytearray(open(IMG, "rb").read())
    foff = data.find(FILE_GUID)
    sec_off = foff + 24
    secsize = u24(data, sec_off)
    comp_off = sec_off + 20
    dec = bytearray(lzma.decompress(bytes(data[comp_off + 4: sec_off + secsize]),
                                    format=lzma.FORMAT_ALONE))
    print("decompressed FV: %d (0x%X)" % (len(dec), len(dec)))

    po = find_pe_rva(dec, BG_PATCH_RVA)
    assert bytes(dec[po:po + 3]) == BG_PATCH_OLD
    dec[po:po + 3] = BG_PATCH_NEW
    print("BootGuardDxe RVA 0x%X @ dec 0x%X -> %s" % (BG_PATCH_RVA, po, BG_PATCH_NEW.hex()))

    fv_start = dec.find(FS_GUID) - 0x10
    fv_len = struct.unpack("<I", dec[fv_start + 0x20:fv_start + 0x24])[0]
    p = fv_start + fv_len
    while p > fv_start and dec[p - 1] == 0xFF:
        p -= 1
    free_off, free_size = p - fv_start, fv_start + fv_len - p
    assert free_off == 0x84B5D0
    rebar = open(FFS, "rb").read()
    assert rebar[0:16] == REBAR_GUID and u24(rebar, 20) == len(rebar)
    assert dec.find(REBAR_GUID) < 0
    assert len(rebar) <= free_size
    abs_off = fv_start + free_off
    dec[abs_off:abs_off + len(rebar)] = rebar
    dec[abs_off + len(rebar): abs_off + free_size] = b"\xFF" * (free_size - len(rebar))
    print("inserted ReBarDxe (%d B)" % len(rebar))

    hits = flip_all(dec)
    total = sum(hits.values())
    print("flipped guards:", hits, "total", total)
    assert total == 21, "expected 21 constant-true guards, got %d" % total

    filters = [{"id": lzma.FILTER_LZMA1, "dict_size": 0x1000000, "lc": 3, "lp": 0, "pb": 2}]
    new_stream = bytearray(lzma.compress(bytes(dec), format=lzma.FORMAT_ALONE, filters=filters))
    assert lzma.decompress(bytes(new_stream), format=lzma.FORMAT_ALONE) == bytes(dec)
    new_stream[5:13] = struct.pack("<Q", len(dec))
    new_stream = bytes(new_stream)
    old_len = secsize - 24
    print("recompressed %d vs region %d (delta %+d)" % (len(new_stream), old_len, len(new_stream) - old_len))
    if len(new_stream) > old_len:
        raise SystemExit("recompressed larger than original")
    data[comp_off + 4: sec_off + secsize] = new_stream + b"\x00" * (old_len - len(new_stream))
    open(OUT, "wb").write(data)

    # self-verify
    out = open(OUT, "rb").read()
    ofoff = out.find(FILE_GUID)
    osecsize = u24(out, ofoff + 24)
    ostream = bytearray(out[ofoff + 48: ofoff + 24 + osecsize])
    stream_after = bytearray(out[ofoff + 48: ofoff + 24 + osecsize])
    ostream[5:13] = b"\xFF" * 8
    deco = lzma.LZMADecompressor(format=lzma.FORMAT_ALONE)
    od = deco.decompress(bytes(ostream))
    assert deco.eof
    left = 0
    for op, name in GUARDS:
        false_pat = bytes([op, 0x82, FALSE_B, 0x02])
        true_pat = bytes([op, 0x82, TRUE_B, 0x02])
        assert od.find(true_pat) < 0, "%s True remains" % name
        print("   %-11s False=%d" % (name, od.count(false_pat)))
    print("SELF-VERIFY: ReBarDxe=%s BG=%s; wrote %s (%d B)"
          % (od.find(REBAR_GUID) > 0, od[po:po + 3].hex(), OUT, len(data)))


if __name__ == "__main__":
    main()
