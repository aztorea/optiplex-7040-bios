#!/usr/bin/env python
"""Wave 6 builder: combine ALL prior waves into ONE image.

Combines everything known-good:
  W1   Above 4G MMIO = Enabled, CSM = Disabled   (vol0 NVAR StdDefaults)
  W2   insert ReBarDxe.ffs (Resizable BAR driver) into DXE FV 5C60F367
  W2b  neutralize BootGuardDxe worker (RVA 0x1070 -> xor eax,eax; ret)
  W5   flip ALL 21 constant-true Setup IFR guards (19 SuppressIf + 1 GrayOutIf
       + 1 DisableIf): True(0x46) -> False(0x47)

The result is a superset of v01..v05.  Offline sandbox build only - never flashes.

Usage: python work\\scripts\\build_v06_all_in_one.py
"""
import os
import struct
import lzma
import hashlib

IMG = os.path.join("work", "bios", "System_BIOS.bin")
OUTDIR = os.path.join("mods", "v06_all_in_one")
OUT = os.path.join(OUTDIR, "System_BIOS.bin")
FFS = os.path.join("tools", "ReBARUEFI_0.3", "ReBarDxe.ffs")
# reference images for the cross-check
V05 = os.path.join("mods", "v05_force_enable", "System_BIOS.bin")

BASELINE_SHA = "505d5f1971ba11f577a10fd16cb1bc52248be5c678e40e5049024ac367b5968e"

REBAR_GUID = struct.pack("<IHH", 0xA8EE1777, 0xA4F5, 0x4345) + bytes.fromhex("9DA413742084D31E")
FILE_GUID = struct.pack("<IHH", 0x9E21FD93, 0x9C72, 0x4C15) + bytes.fromhex("8C4BE77F1DB2D792")
FS_GUID = struct.pack("<IHH", 0x8C8CE578, 0x8A3D, 0x4F1C) + bytes.fromhex("9935896185C32DD3")
BG_GUID = struct.pack("<IHH", 0x1DB43EC9, 0xDF5F, 0x4CF5) + bytes.fromhex("AAF00E85DB4E149A")

BG_PATCH_RVA = 0x1070
BG_PATCH_OLD = bytes.fromhex("4053 48")
BG_PATCH_NEW = bytes.fromhex("31c0 c3")

GUARDS = [(0x0A, "SuppressIf", 19), (0x19, "GrayOutIf", 1), (0x1E, "DisableIf", 1)]
TRUE_B, FALSE_B = 0x46, 0x47

# W1 NVAR defaults (file offsets, see mods/v01_defaults/CHANGES.md)
ABOVE4G, ABOVE4G_OLD, ABOVE4G_NEW = 0x0003DD, 0x00, 0x01
CSM, CSM_OLD, CSM_NEW = 0x000D2A, 0x01, 0x00

SIZE = 0x900000
IBB_START, IBB_END = 0x700000, 0x900000


def sha(b):
    return hashlib.sha256(b).hexdigest()


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
    for op, name, _ in GUARDS:
        pat = bytes([op, 0x82, TRUE_B, 0x02])
        o = n = 0
        while True:
            i = dec.find(pat, o)
            if i < 0:
                break
            o = i + 1
            dec[i + 2] = FALSE_B
            n += 1
        hits[name] = n
    return hits


def container(data):
    """Return (foff, sec_off, secsize, comp_off, decompressed bytearray)."""
    foff = data.find(FILE_GUID)
    assert foff > 0, "file 9E21FD93 not found"
    sec_off = foff + 24
    secsize = u24(data, sec_off)
    comp_off = sec_off + 20
    dec = bytearray(lzma.decompress(bytes(data[comp_off + 4: sec_off + secsize]),
                                    format=lzma.FORMAT_ALONE))
    return foff, sec_off, secsize, comp_off, dec


def main():
    os.makedirs(OUTDIR, exist_ok=True)
    if os.path.exists(OUT):
        os.remove(OUT)

    data = bytearray(open(IMG, "rb").read())
    print("STEP 0  source sha :", sha(data))
    assert sha(data) == sha(open(IMG, "rb").read()), "self read mismatch"
    assert len(data) == SIZE, "unexpected baseline size"
    ibb_pre = bytes(data[IBB_START:IBB_END])

    # ---- container: decompress ----
    foff = data.find(FILE_GUID)
    assert foff > 0, "file 9E21FD93 not found"
    sec_off = foff + 24
    secsize = u24(data, sec_off)
    comp_off = sec_off + 20
    dec = bytearray(lzma.decompress(bytes(data[comp_off + 4: sec_off + secsize]),
                                    format=lzma.FORMAT_ALONE))
    print("STEP 1 decompressed FV: %d (0x%X)" % (len(dec), len(dec)))

    # ---- (W2b) neutralise BootGuardDxe ----
    po = find_pe_rva(dec, BG_PATCH_RVA)
    assert bytes(dec[po:po + 3]) == BG_PATCH_OLD, "unexpected bytes at BG site"
    dec[po:po + 3] = BG_PATCH_NEW
    print("STEP 2 BootGuardDxe RVA 0x%X @ dec 0x%X -> %s" % (BG_PATCH_RVA, po, BG_PATCH_NEW.hex()))

    # ---- (W2) insert ReBarDxe ----
    fv_start = dec.find(FS_GUID) - 0x10
    fv_len = struct.unpack("<I", dec[fv_start + 0x20:fv_start + 0x24])[0]
    p = fv_start + fv_len
    while p > fv_start and dec[p - 1] == 0xFF:
        p -= 1
    free_off, free_size = p - fv_start, fv_start + fv_len - p
    assert free_off == 0x84B5D0, "unexpected free-space offset 0x%X" % free_off
    rebar = open(FFS, "rb").read()
    rguid = struct.pack("<IHH", 0xA8EE1777, 0xA4F5, 0x4345) + bytes.fromhex("9DA413742084D31E")
    assert rebar[0:16] == rguid and u24(rebar, 20) == len(rebar)
    assert dec.find(rguid) < 0, "ReBarDxe already present"
    assert len(rebar) <= free_size
    abs_off = fv_start + free_off
    dec[abs_off:abs_off + len(rebar)] = rebar
    dec[abs_off + len(rebar): abs_off + free_size] = b"\xFF" * (free_size - len(rebar))
    print("STEP 3 inserted ReBarDxe (%d B) at dec 0x%X" % (len(rebar), abs_off))

    # ---- (W5) flip all constant-true guards ----
    hits = flip_all(dec)
    total = sum(hits.values())
    print("STEP 4 flipped guards:", hits, "total", total)
    assert total == 21, "expected 21 flips, got %d" % total
    for op, name, want in GUARDS:
        assert hits[name] == want, "%s: want %d got %d" % (name, want, hits[name])

    # ---- recompress + write into image ----
    filters = [{"id": lzma.FILTER_LZMA1, "dict_size": 0x1000000, "lc": 3, "lp": 0, "pb": 2}]
    new_stream = bytearray(lzma.compress(bytes(dec), format=lzma.FORMAT_ALONE, filters=filters))
    assert lzma.decompress(bytes(new_stream), format=lzma.FORMAT_ALONE) == bytes(dec)
    new_stream[5:13] = struct.pack("<Q", len(dec))
    new_stream = bytes(new_stream)
    old_stream_len = secsize - 20 - 4
    assert len(new_stream) <= old_stream_len, "recompressed larger than original"
    print("STEP 5 recompressed %d (region %d, delta %+d)"
          % (len(new_stream), old_stream_len, len(new_stream) - old_stream_len))
    data[comp_off + 4: sec_off + secsize] = new_stream + b"\x00" * (old_stream_len - len(new_stream))
    assert u24(data, sec_off) == secsize
    assert u24(data, foff + 20) == u24(open(IMG, "rb").read(), foff + 20)

    # ---- (W1) NVAR defaults ----
    assert data[ABOVE4G] == ABOVE4G_OLD, "Above4G unexpected 0x%02X" % data[ABOVE4G]
    assert data[CSM] == CSM_OLD, "CSM unexpected 0x%02X" % data[CSM]
    data[ABOVE4G] = ABOVE4G_NEW
    data[CSM] = CSM_NEW
    print("STEP 6 NVAR defaults: 0x%06X=0x%02X, 0x%06X=0x%02X"
          % (ABOVE4G, ABOVE4G_NEW, CSM, CSM_NEW))

    # ---- guard: IBB must be untouched ----
    assert bytes(data[IBB_START:IBB_END]) == ibb_pre, "IBB changed!"
    print("STEP 7 IBB 0x%X..0x%X UNCHANGED" % (IBB_START, IBB_END))

    os.makedirs(OUTDIR, exist_ok=True)
    open(OUT, "wb").write(data)
    out_sha = sha(data)
    print("STEP 8 wrote %s (%d bytes)\n        sha256 %s" % (OUT, len(data), out_sha))

    # ============ TRIPLE-CHECK ============
    print("\n=== TRIPLE-CHECK ===")
    chk = bytearray(open(OUT, "rb").read())
    base = bytearray(open(IMG, "rb").read())

    # (1) independent re-decompress + assertions
    c_foff = chk.find(FILE_GUID)
    c_sec = u24(chk, c_foff + 24)
    c_stream = bytearray(chk[c_foff + 24 + 20 + 4: c_foff + 24 + c_sec])
    c_stream[5:13] = b"\xFF" * 8
    dc = lzma.LZMADecompressor(format=lzma.FORMAT_ALONE)
    od = dc.decompress(bytes(c_stream))
    assert dc.eof, "output stream has no end marker"
    assert od.find(rguid) > 0, "ReBarDxe missing in output"
    assert od[po:po + 3] == BG_PATCH_NEW, "BG patch missing in output"
    counts = {}
    for op, name, _ in GUARDS:
        assert od.find(bytes([op, 0x82, TRUE_B, 0x02])) < 0, "%s True remains" % name
        counts[name] = od.count(bytes([op, 0x82, FALSE_B, 0x02]))
    assert counts == {"SuppressIf": 19, "GrayOutIf": 1, "DisableIf": 1}, counts
    assert chk[ABOVE4G] == ABOVE4G_NEW and chk[CSM] == CSM_NEW
    print("(1) re-decompress: ReBarDxe=yes BG=yes guards=%s NVAR=ok" % counts)

    # (2) decompressed FV must equal v05_force_enable's decompressed FV
    v05_raw = open(os.path.join("mods", "v05_force_enable", "System_BIOS.bin"), "rb").read()
    v5f = v05_raw.find(FILE_GUID)
    v5sec = u24(v05_raw, v5f + 24)
    v5_stream = bytearray(v05_raw[v5f + 24 + 20 + 4: v5f + 24 + v5sec])
    v5_stream[5:13] = b"\xFF" * 8
    d5 = lzma.LZMADecompressor(format=lzma.FORMAT_ALONE).decompress(bytes(v5_stream))
    assert d5 == od, "combined decompressed FV != v05 decompressed FV"
    print("(2) decompressed FV identical to v05_force_enable: YES")

    # (3) raw byte diff vs v05 = exactly the two NVAR bytes
    d_v05 = [i for i in range(len(chk)) if chk[i] != v05_raw[i]]
    d_v05 = [i for i in range(len(chk)) if chk[i] != v05_raw[i]]
    assert d_v05 == [ABOVE4G, CSM], "unexpected diff vs v05: %s" % [hex(x) for x in d_v05[:20]]
    print("(3) raw diff vs v05 = %s (exactly the 2 W1 bytes)" % [hex(x) for x in d_v05])

    # (4) raw diff vs pristine confined to NVAR(2) + compressed container span
    dr = [i for i in range(len(chk)) if chk[i] != base[i]]
    lo, hi = dr[0], dr[-1]
    allowed = {ABOVE4G, CSM}
    outside = [i for i in dr if i not in allowed and not (comp_off + 4 <= i < sec_off + secsize)]
    assert not outside, "unexpected diffs outside allowed ranges: %s" % [hex(x) for x in outside[:20]]
    assert dr.count(ABOVE4G) == 1 and dr.count(CSM) == 1
    print("(4) diff vs pristine: %d bytes, span 0x%X..0x%X, all within NVAR+container" % (len(dr), lo, hi))

    # (5) guards unchanged
    assert bytes(chk[IBB_START:IBB_END]) == bytes(base[IBB_START:IBB_END])
    print("(5) IBB byte-identical to pristine: YES")
    print("\nALL CHECKS PASSED  sha256(dry-run)=%s" % sha(chk))
    assert sha(chk) == out_sha


if __name__ == "__main__":
    main()
