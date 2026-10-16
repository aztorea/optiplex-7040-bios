import json
from google import genai
from google.genai import types

s = json.load(open(r"C:\Users\Ghost\AppData\Roaming\LawMindEngine\settings.json", encoding="utf-8-sig"))
key = s["api"]["api_keys"]["gemini"]
client = genai.Client(api_key=key)

png = r"C:\Users\Ghost\Desktop\bestproject\work\qemu\dell_text_inv.png"
data = open(png, "rb").read()

models = [
    "gemini-3.8-flash",
    "gemini-3.7-flash",
    "gemini-3.6-flash",
    "gemini-3.5-flash",
    "gemini-2.5-flash",
    "gemini-3.1-pro-preview",
    "gemini-flash-latest",
]
instr = "OCR. This is one line of text from a computer BIOS screen. Transcribe every character exactly. Output only the transcription."
for m in models:
    try:
        r = client.models.generate_content(
            model=m,
            contents=types.Part.from_bytes(data=data, mime_type="image/png"),
            config=types.GenerateContentConfig(system_instruction=instr, max_output_tokens=512),
        )
        txt = (r.text or "").strip()
        print(f"[{m}] -> {txt!r}")
    except Exception as e:
        print(f"[{m}] ERROR {type(e).__name__}: {str(e)[:160]}")
