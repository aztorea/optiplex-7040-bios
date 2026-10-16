import csv
from collections import defaultdict

CSV = r"C:\Users\Ghost\Desktop\bestproject\work\bios\setup_options.csv"
rows = list(csv.DictReader(open(CSV, encoding="utf-8")))

want = ["0x27D0", "0x8008", "0x2768", "0x2786", "0x274C", "0x2772", "0x2757",
        "0x8000", "0x8001", "0x8002", "0x8005", "0x8006", "0x8007", "0x8004",
        "0x2711", "0x2712", "0x2713", "0x2714", "0x2715", "0x2716"]
by = defaultdict(list)
for r in rows:
    by[r["form_id"]].append(r)

for f in want:
    rs = by.get(f, [])
    if not rs:
        continue
    named = [r for r in rs if r["prompt"]]
    print(f"\n===== {f}  {rs[0]['form']}  ({len(named)} named / {len(rs)} total) =====")
    for r in named:
        off = r["var_offset"] or "  -  "
        print(f'  {off:>7}  {r["type"]:<8} {r["prompt"]}  [{r["default"]}]')
