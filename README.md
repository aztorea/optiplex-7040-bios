# optiplex-7040-bios

Modified BIOS research for the **Dell OptiPlex 7040** (BIOS 1.24.0), explained in
plain English — what each change does, how much it matters, and what kind of
performance boost to expect.

**Target machine:** Dell OptiPlex 7040 · Intel i7-6700 · Q170 chipset (**PCIe 3.0**) ·
RTX 3060 (12 GB) · 32 GB RAM.

> This is a personal research repository. Everything here is **analysis and
> sandbox-built images** unless stated otherwise. **Nothing here has been flashed
> to real hardware by the author.**

---

## Read this first (the honesty box)

There are two separate questions, and they have two different levels of proof:

1. **"What does it do?" — this is certain.** Every change below was made by hand on
   a copy of the factory BIOS and then **checked offline** (byte-for-byte structure
   checks). We know exactly what each change does.
2. **"How much faster is it?" — this is projected, not yet measured on this PC.**
   None of these modified images has been flashed to a real machine yet. So every
   speed number below comes from **NVIDIA's own testing and independent reviews**,
   not from this computer.

**Also important for this specific PC:** it uses **PCIe 3.0** (Skylake / Q170) with a
**mid-range** graphics card. Reviews show that on PCIe 3.0 mid-range hardware,
Resizable BAR gives **small, game-dependent gains** — often 1–5%, sometimes nothing,
and occasionally a slight *loss* in a few titles. The big 5–15% headlines come from
high-end cards on PCIe 4.0. Expectations are kept realistic here.

## The 60-second summary

The single change with a real chance of improving gaming is **Resizable BAR** (the CPU
gets to see the GPU's whole 12 GB of memory at once instead of 256 MB at a time).
Everything else is either a **prerequisite** for that (Above 4G decoding, CSM off, and
the Boot Guard bypass needed to boot a modified BIOS at all) or an **access unlock** that
just reveals settings Dell hid — it gives you knobs, it doesn't turn them.

## The master table

| Change | Importance | What it actually does (plain) | Real-world benefit | Performance boost | Proven? |
|---|---|---|---|---|---|
| **Above 4G decoding** | ★★★★☆ prerequisite | Lets the system hand out memory addresses above the 4 GB line to big devices | A 12 GB GPU can't be fully seen by the CPU without this; required for the GPU mod below | **~0% by itself** | Built + offline-verified |
| **CSM off (pure UEFI)** | ★★★☆☆ prerequisite | Turns off legacy "old-BIOS" emulation so it boots modern UEFI-only | Cleaner, slightly faster boot; required for the GPU mod | Boot: a few seconds faster. **0% in games** | Built + offline-verified |
| **Resizable BAR** | ★★★★★ headline feature | The CPU sees the GPU's **whole 12 GB of VRAM as one window** instead of tiny 256 MB slices | Faster, smoother games with fewer stutters — *on titles that support it* | NVIDIA: **a few % up to ~12%**, some titles get *slower*. Independent tests: **~3% avg at 1440p**. On **this PCIe 3.0 mid-range PC: likely ~1–5%, title-dependent, sometimes a small loss** | Image built + offline-verified; **not flashed, not measured here** |
| **Boot Guard bypass** | ★★★★★ required to boot | Disables the firmware's self-integrity check so a *modified* BIOS is allowed to start | **Without it, the modified BIOS simply won't boot.** A tool, not a speed feature (⚠ it also disables a security feature) | **0%** | Built + offline-verified |
| **Hidden menus unlock** | ★★★☆☆ access | Un-hides menus Dell hides (Advanced, Chipset, Security, ASPM) | You can *reach* normally locked settings (power limits, PCIe, ASPM). Exposes knobs | **~0% by itself** — it enables tuning | Offline-verified (menus now appear) |
| **Max hidden options** | ★★☆☆☆ access | Reveals all **19** hidden menus/options | Maximum visibility of settings | Indirect only | Offline-verified |
| **Force-enable everything** | ★☆☆☆☆ riskiest | Reveals **and switches on** all 21 hidden/greyed/disabled items (incl. TPM controls) | Maximum control; most likely to break something | Indirect; **highest risk** | Built + offline-verified |
| **OS / hardware tuning** | ★★★★☆ safe gain | RAM 32→64 GB, driver/power tuning, etc. | Measurable on its own; no firmware risk | Real and measurable (RAM/VMs/AI); **not BIOS** | Doable now |

> **Note:** the hidden-menu / force-enable images are **alternatives** built on the
> Resizable BAR base — you would flash **one** image, not all of them.

## How we would *actually* prove the speed boost

Once flashing is authorized, turn "projected" into "measured on this exact PC":

1. **Baseline** (stock BIOS): 3DMark (Time Spy) + 1–2 ReBAR-sensitive games
   (e.g. Forza Horizon 4, Gears 5) at 1080p and 1440p, 3 runs each — record
   **average FPS** and **1% low FPS**.
2. Flash the Resizable BAR image.
3. Re-run the **exact same** tests, same settings, same driver.
4. Compare average + 1% low, and measure **boot time** with CSM on vs. off.

Until that runs, treat all performance figures as **expected from industry benchmarks,
not measured on this machine.**

## Sources for the performance claims

- NVIDIA (Resizable BAR): "some titles see gains of a few percent, up to ~12%", while a
  few titles get *slower*.
- TechSpot (large multi-game sample): roughly **~3% average** at 1440p.
- smallformfactor.net (ReBAR on **PCIe 3.0**, mid-range RTX 3060 Ti): mostly flat,
  occasional wins up to ~8%, occasional regressions — the closest match to this PC.

## Warning — read before using anything here

- **Flashing modified firmware can permanently brick the machine.** A failed or invalid
  image can leave the system unable to POST.
- **Boot Guard is enabled** on this platform (verified + measured FPF). Because of this,
  any modified in-firmware-volume image must be built on the **W2b base**
  (Boot Guard bypass) or it will not boot. See `FIRMWARE_CATALOG.md` for evidence.
- **Boot Guard bypass** defeats a platform **security feature**. It is included **for
  research and recovery only**. Use only on a machine you own, ideally a spare, with a
  hardware programmer backup on hand.
- **Always** take a full SPI flash backup with a **CH341A-style programmer** before
  flashing anything. Dell's own flasher (`OptiPlex_7040_1.24.0.exe`) rejects modified
  images because of its RSA signature.
- The original Dell installer and the pristine BIOS dump are kept **unmodified** for
  reference and verification.

## Repository layout

| Path | Contents |
|---|---|
| `*.md` | Living research docs (catalogue, plan, analysis, baseline) |
| `mods\` | Sandbox-built modified images + per-build `CHANGES.md` |
| `mods\FLASHING.md` | **Plain-English guide to flashing one of these files** |
| `work\bios\` | Pristine BIOS baseline and extracted firmware analysis |
| `work\scripts\` | Python builders and verification tools |
| `tools\` | Third-party utilities used for analysis |
| `python_embeded\` | *Excluded from git* (large, reinstallable) |
| `tools\qemu\` | *Excluded from git* (large third-party binaries) |

## Build/verify tooling

- `python_embeded\python.exe` (Python 3.11) for `work\scripts\*.py`
- UEFIExtract / UEFITool NE / IFRExtractor / MEAnalyzer / BIOSUtilities (`tools\`)
- ReBarUEFI (`tools\ReBARUEFI_0.3\`) for the Resizable BAR driver

## License

MIT — see [LICENSE](LICENSE). Third-party tools keep their own licenses (e.g. ReBarUEFI).
