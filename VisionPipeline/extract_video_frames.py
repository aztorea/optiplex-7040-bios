"""extract_video_frames.py - pull representative frames out of a video.

Two methods:
  scene    - ffmpeg `select='gt(scene,THRESHOLD)',showinfo` finds cut points,
             then saves one frame at each cut + OFFSET seconds (frame_00.jpg..).
  interval - save N frames evenly spaced across the whole duration.

Usage:
    python extract_video_frames.py <video> --out <dir> [--method scene|interval]
                                   [--threshold 0.25] [--offset 0.4]
                                   [--count 16] [--width 0]  # width>0 scales frames

Requires ffmpeg/ffprobe on PATH (already available via win-get).
"""

import argparse
import os
import re
import shutil
import subprocess
import sys


def find_ffmpeg():
    return shutil.which("ffmpeg")


def find_ffprobe():
    return shutil.which("ffprobe")


def s2ts(seconds):
    """Render a float seconds value as an ffmpeg -ss timestamp like 12.345678."""
    return f"{seconds:.6f}"


def run_quiet(cmd):
    r = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="replace")
    if r.returncode != 0:
        raise RuntimeError(f"{cmd[0]} failed: {r.stderr[:500]}")
    return r


def scene_cut_times(video, threshold):
    """Return list of cut-point times (float seconds) via ffmpeg showinfo."""
    ffmpeg = find_ffmpeg()
    if not ffmpeg:
        raise RuntimeError("ffmpeg not found on PATH")
    cmd = [ffmpeg, "-i", video,
           "-filter:v", f"select='gt(scene,{threshold})',showinfo",
           "-f", "null", "-"]
    r = run_quiet(cmd)
    times = [float(m) for m in re.findall(r"pts_time:([0-9.]+)", r.stderr)]
    return times


def probe_duration(video):
    ffprobe = find_ffprobe()
    if not ffprobe:
        raise RuntimeError("ffprobe not found on PATH")
    r = run_quiet([ffprobe, "-v", "error", "-show_entries", "format=duration",
                   "-of", "default=noprint_wrappers=1:nokey=1", video])
    return float(r.stdout.strip())


def extract(video, out, method, threshold, offset, count, width):
    os.makedirs(out, exist_ok=True)
    for f in os.listdir(out):
        if f.startswith(("frame_", "beat_")):
            os.remove(os.path.join(out, f))

    ffmpeg = find_ffmpeg()
    if not ffmpeg:
        raise RuntimeError("ffmpeg not found on PATH")

    if method == "scene":
        cuts = scene_cut_times(video, threshold)
        times = []
        for i, c in enumerate(cuts):
            t = max(0.0, c + offset)
            # drop duplicates within 0.5s of the previous selection
            if not times or t - times[-1] > 0.5:
                times.append(t)
        # always include a frame near the very start if the first cut is late
        if not times or times[0] > 1.0:
            times.insert(0, 0.4)
    else:
        dur = probe_duration(video)
        times = [dur * (i + 0.5) / count for i in range(count)]

    labels = [f"{method}_{i:02d}" for i in range(len(times))]
    for label, t in zip(labels, times):
        args = [ffmpeg, "-v", "error", "-ss", s2ts(t), "-i", video, "-frames:v", "1", "-q:v", "4"]
        if width > 0:
            args += ["-vf", f"scale={width}:-2"]
        dest = os.path.join(out, f"{label}.jpg")
        r = subprocess.run(args + ["-y", dest], capture_output=True, text=True)
        if r.returncode != 0:
            print(f"  WARN extract {label} @ {t:.2f}s failed: {r.stderr[:200]}")

    print(f"extracted {len(times)} frames to {out}:")
    for label, t in zip(labels, times):
        print(f"  {label}.jpg  @ {t:.2f}s")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("video")
    ap.add_argument("--out", required=True)
    ap.add_argument("--method", default="scene", choices=["scene", "interval"])
    ap.add_argument("--threshold", type=float, default=0.25)
    ap.add_argument("--offset", type=float, default=0.4)
    ap.add_argument("--count", type=int, default=16)
    ap.add_argument("--width", type=int, default=0)
    a = ap.parse_args()
    extract(a.video, a.out, a.method, a.threshold, a.offset, a.count, a.width)


if __name__ == "__main__":
    main()
