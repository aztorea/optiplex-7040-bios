import csv
from collections import Counter, defaultdict

CSV = r"C:\Users\Ghost\Desktop\bestproject\work\bios\setup_options.csv"
OUT = r"C:\Users\Ghost\Desktop\bestproject\work\bios\setup_options_report.txt"

rows = list(csv.DictReader(open(CSV, encoding="utf-8")))

forms = defaultdict(lambda: {"total": 0, "named": 0})
for r in rows:
    key = f'{r["form_id"]} {r["form"]}'.strip()
    forms[key]["total"] += 1
    if r["prompt"]:
        forms[key]["named"] += 1

lines = []
lines.append(f"TOTAL questions: {len(rows)}")
lines.append("")
lines.append("FORMS (questions / named prompts):")
for k, v in sorted(forms.items(), key=lambda kv: -kv[1]["total"]):
    lines.append(f'  {v["named"]:>4}/{v["total"]:<4}  {k}')
lines.append("")

setup = [r for r in rows if r["varstore_id"] == "0x1"]
named = [r for r in setup if r["prompt"]]
lines.append(f"Setup varstore (0x1) questions: {len(setup)}  |  with visible prompt: {len(named)}")
lines.append("")

lines.append("NAMED Setup prompts by form (offset | type | prompt):")
byform = defaultdict(list)
for r in named:
    byform[f'{r["form_id"]} {r["form"]}'.strip()].append(r)
for fk in sorted(byform):
    lines.append(f"\n== {fk} ==")
    for r in byform[fk]:
        lines.append(f'  0x{(r["var_offset"] or "??"):>6} {r["type"]:<8} {r["prompt"]}')

KW = ["4G", "ReSize", "Resiz", "BAR", "CFG", "BIOS Lock", "VT-d", "VTd", "SR-IOV",
      "Speed", "Turbo", "C-State", "CState", "Hyper", "rebar", "Memory", "PCIe",
      "Bifurc", "SATA", "NVMe", "Thunderbolt", "TPM", "Secure Boot", "USB", "Virtual",
      "Above"]
lines.append("\n\n==== KEYWORD HITS (any varstore) ====")
for r in rows:
    p = r["prompt"]
    if p and any(k.lower() in p.lower() for k in KW):
        lines.append(f'  off={r["var_offset"] or "-":>7} vs={r["varstore_id"] or "-":>4} '
                     f'{r["type"]:<8} {p}')

txt = "\n".join(lines)
open(OUT, "w", encoding="utf-8").write(txt)
print(txt[:6000])
print("...")
print("written:", OUT, len(txt), "chars")
