import os
import re
import glob
import csv

DUMP = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin.dump"
OUT_CSV = r"C:\Users\Ghost\Desktop\bestproject\work\docs\modules_catalog.csv"
OUT_MD = r"C:\Users\Ghost\Desktop\bestproject\work\docs\modules_catalog.md"
os.makedirs(os.path.dirname(OUT_CSV), exist_ok=True)

KNOWN = {
    "D6A2CB7F-6A18-4E2F-B43B-9920A733700A": "DXE Core (DxeCore)",
    "52C05B14-0B98-496C-BC3B-04B50211D680": "PEI Core (PeiCore)",
    "899407D7-99FE-43D8-9A21-79EC328CAC21": "Setup (HII config driver)",
    "B1DA0ADF-4F77-4070-A88E-BFFE1C60529A": "AMITSE (Setup Engine)",
    "FE612B72-203C-47B1-8560-A66D946EB371": "AMITSESetupData (NVRAM defaults)",
    "FC510EE7-FFDC-11D4-BD41-0080C73C8881": "DXE apriori file",
    "1B45CC0A-156A-428A-AF62-49864DA0E6E6": "PEI apriori file",
    "17088572-377F-44EF-8F4E-B09FFF46A070": "Intel microcode container (FIT)",
    "CBC91F44-A4BC-4A5B-8696-703451D0B053": "AMI v2 protected ranges hash file",
}

NOISE_NAMES = {
    "Protocol Error", "Setup", "Driver****", "NetworkStackVar",
    "AMIC 25L Series", "GigaDevice 25Q Series", "Wakeup",
}

re_ascii = re.compile(rb"[\x20-\x7e]{4,}")
re_utf16 = re.compile(rb"(?:[\x20-\x7e]\x00){4,}")

NAME_KW = ["Driver", "Dxe", "Pei", "Smm", "Setup", "Service", "Protocol",
           "Init", "Handler", "Manager", "Library", "Console", "Support",
           "Config", "Runtime", "Boot", "Block", "Bus", "Card", "Adapter",
           "Controller", "Engine", "Provider", "Agent", "Policy", "Firmware",
           "Update", "Table", "Device", "Serial", "Port", "CPU", "Cpu", "Pci",
           "USB", "Usb", "SATA", "Sata", "AHCI", "Ahci", "NVMe", "Nvme",
           "Graphics", "Gop", "Network", "Stack", "TPM", "Tpm",
           "PCH", "Pch", "System Agent", "Ami", "AMI", "Dell", "Intel"]
BAD = ("EFI_", "Pcd", "gEfi", "gAmi", "\\", ";", "$", ".data", ".reloc",
       ".text", ".rdata", "http", "Copyright", "%s", "\\r\\n", "0x%", "%d",
       "ProtocolType", "->", "gBS", "gRT", "()")


def strings_from(path):
    try:
        data = open(path, "rb").read()
    except OSError:
        return []
    out = []
    for m in re_ascii.finditer(data):
        out.append(m.group().decode("latin-1"))
    for m in re_utf16.finditer(data):
        out.append(m.group().decode("utf-16-le", "ignore"))
    seen, uniq = set(), []
    for s in out:
        s = s.strip()
        if s and s not in seen:
            seen.add(s)
            uniq.append(s)
    return uniq


def best_name(strings):
    cand = []
    for s in strings:
        if len(s) < 5 or len(s) > 64:
            continue
        if any(b in s for b in BAD) or re.match(r'^[0-9A-Fa-f\-\s]+$', s):
            continue
        hits = [k for k in NAME_KW if k in s]
        if not hits:
            continue
        score = len(hits) * 2
        if re.search(r"(Driver|Service|Protocol|Handler|Manager|Provider|Agent|Engine|Controller|Stack|Library|Table)\b", s):
            score += 4
        if s[0].isupper():
            score += 1
        if re.search(r"[A-Z]", s) and s.lower() != s:
            score += 1
        cand.append((score, len(s), s))
    cand.sort(key=lambda x: (-x[0], x[1]))
    for _, _, s in cand:
        if s not in NOISE_NAMES:
            return s
    return ""


rows = []
for root, dirs, files in os.walk(DUMP):
    if "info.txt" not in files:
        continue
    txt = open(os.path.join(root, "info.txt"), encoding="utf-8", errors="replace").read()
    if "Type: File" not in txt:
        continue

    def field(k):
        m = re.search(rf"^{k}:\s*(.*)$", txt, re.M)
        return m.group(1).strip() if m else ""

    rel = os.path.relpath(root, DUMP)
    volume = rel.split(os.sep)[0]
    pe = glob.glob(os.path.join(root, "*PE32 image section", "body.bin"))
    strs = strings_from(pe[0]) if pe else []
    guid = field("File GUID")
    name = KNOWN.get(guid) or best_name(strs)
    rows.append({
        "volume": volume,
        "subtype": field("Subtype"),
        "guid": guid,
        "offset": field("Offset"),
        "size": field("Full size"),
        "name": name,
        "path": rel,
    })

rows.sort(key=lambda r: (r["volume"], r["subtype"], r["guid"]))
with open(OUT_CSV, "w", newline="", encoding="utf-8") as fh:
    w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

from collections import Counter, OrderedDict
by_sub = Counter(r["subtype"] for r in rows)
named = [r for r in rows if r["name"]]

lines = []
lines.append("# OptiPlex 7040 / BIOS 1.24.0 - Firmware Module Catalog\n")
lines.append(f"- Total FFS files: **{len(rows)}** (named: **{len(named)}**)")
lines.append("- " + ", ".join(f"{k}: {v}" for k, v in by_sub.most_common()) + "\n")
lines.append("Names are best-effort, inferred from embedded strings and a curated GUID table. "
             "GUID is the FFS file GUID. See `modules_catalog.csv` for full data.\n")

vols = OrderedDict()
for r in rows:
    vols.setdefault(r["volume"], []).append(r)
for vol, grp in vols.items():
    vc = Counter(x["subtype"] for x in grp)
    lines.append(f"\n# {vol}  ({len(grp)} files: {', '.join(f'{k} {v}' for k,v in vc.most_common())})\n")
    lines.append("| Type | GUID | Size | Name / Function |")
    lines.append("|------|------|------|-----------------|")
    for r in grp:
        nm = (r["name"] or "").replace("|", "\\|")
        lines.append(f"| {r['subtype']} | `{r['guid']}` | {r['size']} | {nm} |")

open(OUT_MD, "w", encoding="utf-8").write("\n".join(lines) + "\n")

print(f"modules={len(rows)} named={len(named)}")
print("volumes:", list(vols.keys()))
print("MD:", OUT_MD)
