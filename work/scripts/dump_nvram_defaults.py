#!/usr/bin/env python3
"""Decode the baked-in NVRAM `Setup` default store (4928 B = 0x1340) and compare
each question's stored default against the IFR-declared default.

Inputs:
  work/bios/System_BIOS.bin.dump/4 FD44D4FE.../0 EB3001D5.../.../0 Setup/body.bin  (via path arg)
  work/bios/setup_options.csv  (form/varstore/offset/size/default)
Outputs:
  work/docs/nvram_defaults.csv
  stdout: annotated key offsets
"""
import csv, os, sys

ROOT = r"C:\Users\Ghost\Desktop\bestproject"
SETUP_DEFAULT = os.path.join(
    ROOT,
    r"work\bios\System_BIOS.bin.dump\4 FD44D4FE-239B-4C57-B96D-E47E066A50A3"
    r"\11 NVRAM external defaults\0 EE4E5898-3914-4259-9D6E-DC7BD79403CF"
    r"\0 Raw section\0 StdDefaults\0 Setup\body.bin",
)
OPTIONS = os.path.join(ROOT, r"work\bios\setup_options.csv")
OUT = os.path.join(ROOT, r"work\docs\nvram_defaults.csv")

with open(SETUP_DEFAULT, "rb") as f:
    buf = f.read()

def u(off, size):
    if off < 0 or off + size > len(buf):
        return None
    return int.from_bytes(buf[off:off + size], "little")

def hx(v):
    return f"0x{v:X}"

def ifr_val(s):
    s = (s or "").strip()
    if not s:
        return None
    if "=" in s:  # e.g. "Enabled=1", "256MB=2", "Power Off=0"
        s = s.rsplit("=", 1)[1].strip()
    try:
        return int(s, 0)
    except ValueError:
        return None

rows = []
with open(OPTIONS, newline="", encoding="utf-8", errors="replace") as f:
    for r in csv.DictReader(f):
        off = ifr_val(r.get("var_offset", ""))
        size = ifr_val(r.get("size", ""))
        if off is None or size is None or size == 0 or size > 8:
            continue
        stored = u(off, size)
        if stored is None:
            continue
        iv = ifr_val(r.get("default", ""))
        rows.append({
            "form": r.get("form", ""),
            "prompt": r.get("prompt", ""),
            "question_id": r.get("question_id", ""),
            "var_offset": hx(off),
            "size": size,
            "stored_default": hx(stored),
            "ifr_default": r.get("default", ""),
            "match": "Y" if iv == stored else ("." if iv is None else "N"),
        })

os.makedirs(os.path.dirname(OUT), exist_ok=True)
with open(OUT, "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

print(f"wrote {len(rows)} rows -> {OUT}")

KEY = {
    0xAF: "CFG lock", 0x136: "VT-x", 0x79: "HT", 0x82: "Turbo",
    0x7E: "Speed Shift", 0x355: "Above4G MMIO", 0xCA2: "CSM Support",
    0x461: "BIOS Lock", 0x37E: "Memory Freq", 0x37D: "Max TOLUD",
    0x2B9: "Aperture Size", 0x350: "DVMT Pre-Alloc", 0x37C: "ECC Support",
}
print("\n--- key baked defaults (window) ---")
for off, name in sorted(KEY.items()):
    print(f"  0x{off:04X} {name:<16} : " + " ".join(f"{b:02X}" for b in buf[max(0,off-2):off+4]))

mism = [r for r in rows if r["match"] == "N"]
print(f"\nrows where stored != IFR-declared default: {len(mism)} (see CSV 'match' column)")
for r in mism[:20]:
    print(f"  {r['var_offset']}: stored={r['stored_default']} ifr={r['ifr_default']}  {r['prompt'][:48]}")
