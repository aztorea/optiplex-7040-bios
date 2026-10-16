# AGENTS.md — project rules for opencode

## HARD SAFETY RULES (do not violate)

1. **NEVER flash, write, or otherwise modify the running system's firmware,
   SPI flash, BIOS region, ME/CSME region, NVRAM/CMOS, or any hardware
   state — unless the user's message contains the EXACT phrase:**

   > **I fully authorize you**

   Without that exact phrase, all firmware work is **analysis and sandbox
   image building only**. Read-only probes are permitted, but still confirm
   before any command that touches the SPI/flash.

2. The original Dell installer is **never** modified:
   `OptiPlex_7040_1.24.0.exe`
   (SHA256 `C1B7E6E5EDCA9FE4939F083C7745F7726E7B343FCAEF36EFB4A316F656709F4A`).

3. The pristine extracted BIOS is the diff baseline and is **never** edited:
   `work\bios\System_BIOS.bin`
   (SHA256 `505D5F1971BA11F577A10FD16CB1BC52248BE5C678E40E5049024AC367B5968E`).

4. All built/modified images live under `work\mods\<variant>\` with a
   `CHANGES.md` describing every byte changed and the verification performed.

## Project

- Target: Dell OptiPlex 7040, BIOS 1.24.0 (AMI Aptio V, Boot Guard enabled).
- Goal: compile `UpgradeList.md` and build improved firmware images
  (defaults, ReBAR, hidden menus) plus OS/hardware tuning.
- Living docs: `UpgradeList.md`, `OPPORTUNITIES.md`, `FIRMWARE_CATALOG.md`,
  `BIOS_UPGRADE_ANALYSIS.md`, `TASK_PLAN.md`, `SYSTEM_BASELINE.md`.
- Sandbox: `work\mods\original\` (pristine copy) and `work\mods\v01_defaults\`
  (first build: Above 4G = enabled, CSM = disabled).
- Tooling: `python_embeded\python.exe` (3.11.9), `tools\` (UEFIExtract,
  UEFITool NE, IFRExtractor, MEAnalyzer, BIOSUtilities), 7-Zip.

## Shell notes (win32 / pwsh)

- Heredocs do NOT work; write scripts to files and run them.
- Elevation requires user UAC click (`Start-Process pwsh -Verb RunAs -Wait`).
