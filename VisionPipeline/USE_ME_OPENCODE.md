# OpenCode Vision Pipeline — Runbook (for future-me)

This folder is the **permanent home for the proven "see" pipeline** that was
battle-tested on the Verizon LEGO Broll: it lets me (opencode) look at any image
or video on this machine through a vision LLM even when my own context cannot
display media.

Everything here is **proven** — `describe.py` + `describe_all.py` are byte-for-byte
the versions that successfully described the storyboard PNG and all 19
`finall.mp4` beat frames. `extract_video_frames.py` is the wrapper that reproduced
those same 19 scene-cut timestamps exactly.

## Non-negotiables (learned the hard way)
1. **Do NOT rewrite/refactor these scripts.** They work. If you need different
   behavior, add an argument with the current behavior as the default, or ask.
2. **Always use `gemini-flash-lite-latest` as the model.** It is the only proven,
   reliably available one. `gemini-3.6-flash` and `gemini-3.5-flash` intermittently
   return **503 "high demand"**; `gemini-2.5-flash` is deprecated. NVIDIA vision
   (`nvidia/vila`) is a slow fallback only, and its calls have read-timed-out once.
3. **The system prompt field is `system_instruction`, NOT `instructions`.**
   `instructions` raises a ValidationError. `describe.py` already uses the right
   name — do not "fix" it.

## Environment facts
- **Use ONLY the project embedded Python:** `C:\Users\Ghost\Desktop\bestproject\python_embeded\python.exe`
  (3.11.9). It has `google-genai`, `Pillow`, `requests` installed. Do NOT use the system Python 3.10
  or any other interpreter. Install any new deps with
  `python_embeded\python.exe -m pip install <pkg>`.
- (Historical) the pipeline was originally proven on system Python 3.10; the embedded 3.11 works identically.
- API keys are read **at runtime** from `%APPDATA%\LawMindEngine\settings.json`
  (`api.api_keys.gemini` and `.nvidia`). Nothing here stores keys. The
  `C:\Users\Ghost\Desktop\lawmindengine` project is **never modified** — only read.
- ffmpeg/ffprobe on PATH (win-get Gyan FFmpeg 8.1.2 full build).

## Files here
| file | purpose | proven? |
|---|---|---|
| `describe.py` | describe ONE image → prints text | YES (storyboard, all beats) |
| `describe_all.py` | batch-describe a folder's `.jpg`s → `analysis.txt` | YES (19/19 beats); dir/out now args, defaults = proven paths |
| `extract_video_frames.py` | video → representative frames | YES (reproduced exact 19-beat timestamps) |
| `USE_ME_OPENCODE.md` | this runbook | — |

---

## Image → description (proven)
Single image:
```powershell
python "C:\Users\Ghost\Desktop\LawMindVideo\VisionPipeline\describe.py" <path\to.png> "Your instruction here"
```
Options: `--model gemini-flash-lite-latest` (default), `--max-tokens N` (default
2048), `--provider nvidia` (opt-in fallback, slower). PNG/JPEG auto-detected.

Batch folder of `.jpg`s → writes `analysis.txt` (`##### filename` sections):
```powershell
python "C:\Users\Ghost\Desktop\LawMindVideo\VisionPipeline\describe_all.py" <dir> [--out <file>] [--max-tokens 700]
```
With no args it reproduces the exact original run (defaults = the proven tmp beats
dir + analysis.txt). The batch instruction is the proven LEGO shot-analyst prompt
(shot size, subject, clothing, action, props, setting, lighting).

## Video → understanding (proven on finall.mp4)
1. Probe (optional):
   ```powershell
   ffprobe -v error -show_entries format=duration:stream=width,height,avg_frame_rate -of default=noprint_wrappers=1 <video>
   ```
2. Extract frames (scene-cut method = the proven default):
   ```powershell
   python "C:\Users\Ghost\Desktop\LawMindVideo\VisionPipeline\extract_video_frames.py" <video> --out <dir> [--method scene|interval] [--threshold 0.25] [--offset 0.4] [--count 16] [--width 0]
   ```
   - `scene`: ffmpeg `select='gt(scene,0.25)',showinfo`, one frame at **each cut
     + 0.4 s**, dedup if <0.5 s apart, plus a 0.4 s frame if the first cut is late.
     (0.4 s offset lands past the crossfade blend. Proven: finall.mp4 → 19 frames
     @ 0.43, 2.24, 4.64, 6.37, 10.48, … 59.26 s, exactly matching the manual run.)
   - `interval`: N evenly spaced frames (default 16).
3. Describe them:
   ```powershell
   python "C:\Users\Ghost\Desktop\LawMindVideo\VisionPipeline\describe_all.py" <out_dir> --out analysis.txt
   ```
4. Read `analysis.txt` and treat it as ground truth.

## Recommended compare-check (render vs. reference beat)
```
Compare frame K of the rendered clip to the reference beat image. List exact
matches and every mismatch: shot size, subject identity, props, pose, lighting,
signage. Verdict: MATCH or list the top 3 fixes needed.
```

## Workflow recipe for any future video
```
extract_video_frames.py <video> --out <beatdir>      # scene method
describe_all.py <beatdir> --out analysis.txt         # ground-truth shot sheet
<read analysis.txt>                                   # I now "see" the video
```
Optionally re-render → extract frames → `describe.py` compare-check against the
reference beat → iterate the clip prompt until MATCH.