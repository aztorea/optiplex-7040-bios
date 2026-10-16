import argparse
import os
import subprocess
import sys

DEFAULT_DIR = r"C:\Users\Ghost\AppData\Local\Temp\opencode\beats"
DEFAULT_OUT = r"C:\Users\Ghost\AppData\Local\Temp\opencode\beats\analysis.txt"

INSTRUCTION = (
    "You are a shot analyst for a video that will be re-created as a LEGO stop-motion short. "
    "Describe this single video frame precisely. Cover: (1) shot size and camera angle, "
    "(2) who/what is in frame (age, clothing, gender), (3) the exact action or pose, "
    "(4) objects and props in frame and where, (5) setting/location and background, "
    "(6) lighting. Output as compact but complete plain text, no markdown headers."
)

SCRIPT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "describe.py")


def run_describe(path, max_tokens):
    r = subprocess.run(
        [sys.executable, SCRIPT, path, INSTRUCTION, "--max-tokens", str(max_tokens)],
        capture_output=True, text=True, encoding="utf-8", errors="replace",
    )
    return r.stdout.strip() if r.returncode == 0 else "ERROR: " + r.stderr.strip()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("dir", nargs="?", default=DEFAULT_DIR, help="folder of images (default: proven beats dir)")
    ap.add_argument("--out", default=DEFAULT_OUT, help="output analysis file (default: proven path)")
    ap.add_argument("--max-tokens", type=int, default=700)
    a = ap.parse_args()

    lines = []
    for name in sorted(os.listdir(a.dir)):
        if not name.endswith(".jpg"):
            continue
        if name.endswith(".txt"):
            continue
        path = os.path.join(a.dir, name)
        text = run_describe(path, a.max_tokens)
        lines.append(f"##### {name}")
        lines.append(text)
        lines.append("")
        print(f"===== {name}")
        print(text)
        print()
    with open(a.out, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print("saved to", a.out)


if __name__ == "__main__":
    main()