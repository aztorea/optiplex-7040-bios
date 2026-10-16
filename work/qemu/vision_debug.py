import json, sys, base64
from google import genai
from google.genai import types

SETTINGS = r"C:\Users\Ghost\AppData\Roaming\LawMindEngine\settings.json"
s = json.load(open(SETTINGS, encoding="utf-8-sig"))
key = s.get("api", {}).get("api_keys", {}).get("gemini") or ""
print("key len:", len(key), "prefix:", key[:4] + "..." if key else "NONE")
client = genai.Client(api_key=key)

# 1) text-only sanity check
try:
    r = client.models.generate_content(
        model="gemini-flash-lite-latest",
        contents="Reply with exactly: PONG",
        config=types.GenerateContentConfig(max_output_tokens=64),
    )
    print("TEXT-ONLY ->", repr(r.text))
except Exception as e:
    print("TEXT-ONLY ERROR:", type(e).__name__, str(e)[:400])

# 2) image check, verbose
png = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\dell_text_inv.png"
data = open(png, "rb").read()
print("png bytes:", len(data))
try:
    r = client.models.generate_content(
        model="gemini-flash-lite-latest",
        contents=types.Part.from_bytes(data=data, mime_type="image/png"),
        config=types.GenerateContentConfig(
            system_instruction="OCR the image. Output only the transcription.",
            max_output_tokens=512,
        ),
    )
    print("IMAGE ->", repr(r.text))
    print("CANDIDATES ->", len(getattr(r, "candidates", []) or []))
    print("RAW PARTS ->", getattr(r, "candidates", None))
except Exception as e:
    print("IMAGE ERROR:", type(e).__name__, str(e)[:400])
