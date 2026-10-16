# How to Flash One of the Modded BIOS Files (Plain-English Guide)

> **Read this first**
>
> - **Flashing modified firmware can permanently brick the machine.** A failed or
>   interrupted flash can leave the system unable to POST.
> - **Never flash without a full backup you can restore** (Step 3).
> - **Nothing here has been flashed by the author.** These images are sandbox
>   builds, verified offline only. Flashing is your own risk — ideally on a spare
>   OptiPlex.

## 1. Pick exactly ONE file

Each folder under `mods\` holds a complete BIOS region named `System_BIOS.bin`
(9 MB) plus a `CHANGES.md` describing every change. **You flash one file — never
mix files from two folders.**

| Folder | What it contains | Best for |
|---|---|---|
| `original\` | Untouched factory copy | restoring stock |
| `v01_defaults\` | Above 4G **on**, CSM **off** (defaults only, no ReBAR) | clean-UEFI defaults only |
| `v02_rebar\` | Resizable BAR driver (no Boot Guard bypass — **will not boot**) | reference only |
| `v02b_rebar_bgbypass\` | Resizable BAR **+ Boot Guard bypass** | ReBAR and nothing else |
| `v03_hidden\` | ReBAR + bypass + **5 unlocked menus** | **best all-round** |
| `v04_hidden_opts\` | ReBAR + bypass + all **19** hidden options | maximum visibility |
| `v05_force_enable\` | ReBAR + bypass + force-enable all **21** items | maximum control, **highest risk** |

> **Boot Guard is enabled on this PC.** Any modified image **must** include the
> bypass (that is why `v02b` and later exist). Without it, the modified BIOS
> **will not boot**.

> **Important — ReBAR needs two extra settings ON.** The ReBAR images do **not**
> change the *defaults* for them, so after flashing you must make sure
> **Above 4G Decoding = Enabled** and **CSM = Disabled** (see Step 5).

## 2. Get these ready first

- **CH341A SPI programmer + SOIC8 clip** — for the backup and for un-bricking.
  This is your safety net. **(strongly recommended)**
- A flasher: the **Intel FPT** tool (software) *or* the programmer (hardware).
- A stable, mains-powered system. **Never flash on battery power.**
- The single `System_BIOS.bin` you chose.

## 3. Make a full backup first (do NOT skip)

**A) With the programmer — the backup that saves you:**

1. Shut down, unplug power, remove the CMOS coin cell.
2. Clip the SOIC8 clip onto the SPI flash chip (16 MB, Winbond 25Q128-class).
3. In the programmer software (e.g. NeoProgrammer / flashrom): **Read**, then
   **Save** the full 16 MB image, e.g. `stock-full-16MB.bin`. Read it **twice**
   and confirm the two reads match. **Keep this file somewhere safe.**

**B) With Intel FPT (no case opening):**

```
fptw64.exe -bios -d stock-bios-region.bin
```

If FPT refuses ("region is locked"), use the programmer instead.

## 4. Flash the chosen file

**Method A — Intel FPT (software, easiest).** Run as Administrator:

```
fptw64.exe -bios -f "C:\path\to\mods\v03_hidden\System_BIOS.bin"
```

Wait until it completes. **Do not interrupt or power off.** Then reboot.
(The official Dell flasher `OptiPlex_7040_1.24.0.exe` **rejects** modified
images because of its signature — do not try it.)

**Method B — CH341A programmer (hardware).**

1. Power off, unplug, remove the coin cell, clip onto the chip.
2. The file here is the **9 MB BIOS region**. On the **16 MB** chip it normally
   sits at offset **`0x700000`** (the top 9 MB). Either place the 9 MB file at
   that offset inside a copy of your 16 MB dump, or use your tool's
   "write region / offset" option. **Verify the offset against your own dump
   before writing — getting it wrong bricks the board.**
3. **Write**, then **Verify**.
4. Replace the coin cell, reassemble, boot.

## 5. Turn on what Resizable BAR needs

Resizable BAR only works with **Above 4G Decoding = Enabled** and
**CSM = Disabled**:

1. Enter BIOS Setup (**F2** at boot).
2. If you flashed a hidden-menu image (`v03`+), open the now-unlocked
   Advanced / Chipset menu and set **Above 4G Decoding → Enabled**,
   **CSM → Disabled**.
3. If those options are not visible, flash `v03_hidden` (it reveals the menus)
   or write the settings with `AMISCE`/`SCE`.
4. **Save & Exit.** To apply the baked defaults, do **Load Setup Defaults**
   and/or clear CMOS once.

## 6. Confirm it worked

- Boot Windows. NVIDIA Control Panel → System Information, or GPU-Z
  (Advanced → PCIe), should show **Resizable BAR: Yes**.
- If it says **No**, Above 4G / CSM are not set yet — repeat Step 5.

## 7. If it will not boot (recovery)

1. Clear CMOS (coin cell / jumper) and try again.
2. If still dead, use the programmer to write back your **full 16 MB backup**
   from Step 3A. That restores the stock BIOS and the machine should POST again.

## The rules

- **One image only.** Never combine folders.
- **Always** have the full-chip backup before flashing.
- Do not interrupt a flash; do not flash on battery.
- These images are **unproven** — this is your machine and your risk.
