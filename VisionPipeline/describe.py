import argparse
import json
import base64
import sys

SETTINGS = r"C:\Users\Ghost\AppData\Roaming\LawMindEngine\settings.json"


def get_gemini_client():
    from google import genai
    s = json.load(open(SETTINGS, encoding="utf-8-sig"))
    key = s.get("api", {}).get("api_keys", {}).get("gemini") or ""
    if not key:
        raise RuntimeError("no gemini key in settings.json")
    return genai.Client(api_key=key)


def describe_image_gemini(path, instruction, model="gemini-flash-lite-latest", max_tokens=2048):
    from google.genai import types
    client = get_gemini_client()
    data = open(path, "rb").read()
    mime = "image/png" if path.lower().endswith(".png") else "image/jpeg"
    resp = client.models.generate_content(
        model=model,
        contents=types.Part.from_bytes(data=data, mime_type=mime),
        config=types.GenerateContentConfig(system_instruction=instruction, max_output_tokens=max_tokens),
    )
    return resp.text or ""


def describe_image_http_image_url(path, instruction):
    import requests
    s = json.load(open(SETTINGS, encoding="utf-8-sig"))
    key = s.get("api", {}).get("api_keys", {}).get("nvidia") or ""
    if not key:
        raise RuntimeError("no nvidia key")
    ext = path.lower().rsplit(".", 1)[-1]
    mime = "image/png" if ext == "png" else "image/jpeg"
    b64 = base64.b64encode(open(path, "rb").read()).decode()
    body = {
        "model": "nvidia/vila",
        "max_tokens": 1024,
        "messages": [
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": instruction},
                    {"type": "image_url", "image_url": {"url": f"data:{mime};base64,{b64}"}},
                ],
            }
        ],
    }
    r = requests.post(
        "https://integrate.api.nvidia.com/v1/chat/completions",
        headers={"Authorization": f"Bearer {key}", "Content-Type": "application/json"},
        json=body,
        timeout=180,
    )
    r.raise_for_status()
    return r.json()["choices"][0]["message"]["content"]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("path")
    ap.add_argument("instruction")
    ap.add_argument("--model", default="gemini-flash-lite-latest")
    ap.add_argument("--max-tokens", type=int, default=2048)
    ap.add_argument("--provider", default="gemini", choices=["gemini", "nvidia"])
    a = ap.parse_args()
    try:
        if a.provider == "nvidia":
            print(describe_image_http_image_url(a.path, a.instruction))
        else:
            print(describe_image_gemini(a.path, a.instruction, a.model, a.max_tokens))
    except Exception as e:
        print("ERROR:", type(e).__name__, str(e)[:500], file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()