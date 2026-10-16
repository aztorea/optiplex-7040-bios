import re
import csv

IFR = r"C:\Users\Ghost\Desktop\bestproject\work\bios\setup_ifr.txt"
OUT = r"C:\Users\Ghost\Desktop\bestproject\work\bios\setup_options.csv"

text = open(IFR, "r", encoding="utf-8", errors="replace").read()

STARTERS = ("OneOfOption", "OneOf", "CheckBox", "Numeric", "Text", "Ref", "Action",
            "SuppressIf", "GrayOutIf", "End", "Subtitle", "Form", "FormSet",
            "VarStore", "Goto", "Inconsistent", "NoSubmit", "OrderedList", "FormMap")
splitter = re.compile(r'\n(?=\s*(?:' + "|".join(STARTERS) + r')\b)')
records = [re.sub(r'\s+', ' ', r).strip() for r in splitter.split(text)]

re_prompt = re.compile(r'Prompt:\s*"(?P<prompt>(?:[^"\\]|\\.)*)"')
re_qid = re.compile(r'QuestionId:\s*(0x[0-9A-Fa-f]+)')
re_vs = re.compile(r'VarStoreId:\s*(0x[0-9A-Fa-f]+)')
re_vo = re.compile(r'VarOffset:\s*(0x[0-9A-Fa-f]+)')
re_vsi = re.compile(r'VarStoreInfo:\s*(0x[0-9A-Fa-f]+)')
re_size = re.compile(r'\bSize:\s*(\d+)')
re_form = re.compile(r'^Form FormId:\s*(0x[0-9A-Fa-f]+), Title:\s*"(?P<t>(?:[^"\\]|\\.)*)"')
re_sub = re.compile(r'^Subtitle Prompt:\s*"(?P<t>(?:[^"\\]|\\.)*)"')
re_opt = re.compile(r'^OneOfOption Option:\s*"(?P<o>(?:[^"\\]|\\.)*)" Value:\s*(?P<v>-?\d+)(?P<f>.*)$')
re_qhead = re.compile(r'^(OneOf|CheckBox|Numeric|Text|Ref|Action)\b')

rows = []
cur_form_id = cur_form = cur_sub = ""
pending = None


def g(rx, s, grp=1):
    m = rx.search(s)
    return m.group(grp) if m else ""


for rec in records:
    if not rec:
        continue
    m = re_form.match(rec)
    if m:
        cur_form_id, cur_form, cur_sub = m.group(1), m.group("t"), ""
        continue
    m = re_sub.match(rec)
    if m:
        cur_sub = m.group("t")
        continue
    if rec.startswith("SuppressIf") or rec.startswith("GrayOutIf") or rec == "End":
        continue

    m = re_opt.match(rec)
    if m and pending is not None:
        if "Default" in m.group("f"):
            pending["default"] = m.group("o") + "=" + m.group("v")
        continue

    m = re_qhead.match(rec)
    if m:
        pm = re_prompt.search(rec)
        pending = {
            "form_id": cur_form_id, "form": cur_form, "subtitle": cur_sub,
            "type": m.group(1),
            "prompt": (pm.group("prompt").replace('\\"', '"').strip() if pm else ""),
            "question_id": g(re_qid, rec), "varstore_id": g(re_vs, rec),
            "var_offset": g(re_vo, rec), "varstore_info": g(re_vsi, rec),
            "size": g(re_size, rec), "default": "",
        }
        rows.append(pending)
        continue

with open(OUT, "w", newline="", encoding="utf-8") as fh:
    w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

setup = [r for r in rows if r["varstore_id"] == "0x1"]
print("total:", len(rows), "| Setup(0x1):", len(setup),
      "| Setup w/offset:", len([r for r in setup if r["var_offset"]]))
print("named prompts:", len([r for r in rows if r["prompt"]]))
for name in ["Above 4GB MMIO BIOS assignment", "CFG lock", "BIOS Lock",
             "Intel Virtualization Technology", "Intel(R) Speed Shift Technology",
             "Hyper-Threading", "C-State Auto Demotion", "Turbo Mode"]:
    for r in rows:
        if r["prompt"] == name:
            print(f'  {name:38} vs={r["varstore_id"]:>4} off={r["var_offset"]:>6} '
                  f'default={r["default"]} qid={r["question_id"]}')
