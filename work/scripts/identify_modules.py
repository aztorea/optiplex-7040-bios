import os
import re
import glob
import csv

DUMP = r"C:\Users\Ghost\Desktop\bestproject\work\bios\System_BIOS.bin.dump"
OUT = r"C:\Users\Ghost\Desktop\bestproject\work\docs\module_names.csv"
os.makedirs(os.path.dirname(OUT), exist_ok=True)

re_ascii = re.compile(rb"[\x20-\x7e]{4,}")
re_utf16 = re.compile(rb"(?:[\x20-\x7e]\x00){4,}")

NAME_KW = ["Driver", "Dxe", "Pei", "Smm", "Setup", "Service", "Protocol",
           "Init", "Handler", "Manager", "Library", "Console", "Support",
           "Config", "Runtime", "Boot", "Block", "Bus", "Card", "Adapter",
           "Controller", "Engine", "Provider", "Agent", "Policy", "Firmware",
           "Update", "Table", "Device", "Serial", "Port", "CPU", "Cpu", "Pci",
           "USB", "Usb", "SATA", "Sata", "AHCI", "Ahci", "NVMe", "Nvme",
           "Graphics", "Gop", "Network", "Stack", "TPM", "Tpm", "Me ", "ME ",
           "PCH", "Pch", "System Agent", "TSE", "Ami", "AMI", "Dell", "Intel"]
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
        # a clean driver name is usually one line, starts with a capital / brand
        if re.search(r"(Driver|Service|Protocol|Handler|Manager|Provider|Agent|Engine|Controller|Stack|Library|Table)\b", s):
            score += 4
        if s[0].isupper():
            score += 1
        if re.search(r"[A-Z]", s) and s.lower() != s:
            score += 1
        cand.append((score, len(s), s))
    cand.sort(key=lambda x: (-x[0], x[1]))
    return cand[0][2] if cand else ""


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

    pe = glob.glob(os.path.join(root, "*PE32 image section", "body.bin"))
    strs = strings_from(pe[0]) if pe else []
    rows.append({
        "subtype": field("Subtype"),
        "guid": field("File GUID"),
        "offset": field("Offset"),
        "size": field("Full size"),
        "name_guess": best_name(strs),
        "n_strings": len(strs),
        "path": os.path.relpath(root, DUMP),
    })

rows.sort(key=lambda r: (r["subtype"], r["guid"]))
with open(OUT, "w", newline="", encoding="utf-8") as fh:
    w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

named = [r for r in rows if r["name_guess"]]
print(f"modules: {len(rows)}   named: {len(named)}")
for r in rows:
    tag = r["name_guess"] or "(no PE32 strings)"
    print(f'{r["subtype"]:<12} {r["guid"]}  {tag}')
