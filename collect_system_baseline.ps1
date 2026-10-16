# collect_system_baseline.ps1
# Read-only system inventory for the BIOS-deconstruction project.
# Produces baseline files under work\logs\. Makes NO changes to the system.
#
# Usage:
#   pwsh -File .\collect_system_baseline.ps1
# For the admin-gated sections (TPM/BitLocker/Defender exclusions), run from an
# elevated PowerShell window.

$ErrorActionPreference = 'SilentlyContinue'
$root = $PSScriptRoot
$logs = Join-Path $root 'work\logs'
New-Item -ItemType Directory -Path $logs -Force | Out-Null

$raw      = Join-Path $logs 'system_baseline_raw.txt'
$programs = Join-Path $logs 'system_installed_programs.txt'
$pyPkgs   = Join-Path $logs 'system_python_packages.txt'
$py       = Join-Path $root 'python_embeded\python.exe'

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$t = @()
$t += "# System baseline capture  $(Get-Date -Format 'u')"
$t += "Running as Administrator: $isAdmin"
$t += ""
$t += "===== ComputerSystem ====="
$t += (Get-CimInstance Win32_ComputerSystem       | Format-List * | Out-String)
$t += "===== BIOS ====="
$t += (Get-CimInstance Win32_BIOS                 | Format-List * | Out-String)
$t += "===== BaseBoard ====="
$t += (Get-CimInstance Win32_BaseBoard            | Format-List * | Out-String)
$t += "===== System Enclosure ====="
$t += (Get-CimInstance Win32_SystemEnclosure      | Format-List * | Out-String)
$t += "===== CPU ====="
$t += (Get-CimInstance Win32_Processor            | Format-List * | Out-String)
$t += "===== Physical Memory ====="
$t += (Get-CimInstance Win32_PhysicalMemory       | Format-List * | Out-String)
$t += "===== Memory Array ====="
$t += (Get-CimInstance Win32_PhysicalMemoryArray  | Format-List * | Out-String)
$t += "===== Disk Drives ====="
$t += (Get-CimInstance Win32_DiskDrive            | Format-List * | Out-String)
$t += "===== Get-Disk / PhysicalDisk / Partition ====="
$t += (Get-Disk        | Format-Table -AutoSize | Out-String -Width 250)
$t += (Get-PhysicalDisk| Format-Table -AutoSize | Out-String -Width 250)
$t += (Get-Partition   | Format-Table -AutoSize | Out-String -Width 200)
$t += (Get-Volume      | Format-Table -AutoSize | Out-String -Width 200)
$t += "===== Video ====="
$t += (Get-CimInstance Win32_VideoController      | Format-List * | Out-String)
$t += "===== Network ====="
$t += (Get-NetAdapter     | Format-Table -AutoSize | Out-String -Width 250)
$t += (Get-NetIPConfiguration | Out-String)
$t += "===== OS ====="
$t += (Get-CimInstance Win32_OperatingSystem      | Format-List * | Out-String)
$t += (systeminfo | Out-String)
$t += "===== Updates ====="
$t += (Get-CimInstance Win32_QuickFixEngineering  | Format-Table -AutoSize | Out-String -Width 200)
$t += "===== Users ====="
$t += (Get-LocalUser | Format-Table -AutoSize | Out-String -Width 200)
$t += (Get-LocalGroupMember -Group Administrators | Out-String)
$t += "===== Security ====="
$t += ("Confirm-SecureBootUEFI: " + (Confirm-SecureBootUEFI))
$t += ("UEFISecureBootEnabled (reg): " + (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\State' -Name UEFISecureBootEnabled).UEFISecureBootEnabled)
$t += (Get-Tpm | Out-String)
$t += (Get-BitLockerVolume | Format-List MountPoint,VolumeStatus,ProtectionStatus,EncryptionMethod | Out-String)
$t += (Get-MpComputerStatus | Format-List AMServiceEnabled,AntivirusEnabled,RealTimeProtectionEnabled,AntivirusSignatureVersion,AMEngineVersion | Out-String)
$t += (Get-MpPreference | Select-Object -ExpandProperty ExclusionPath)
$t += "===== GPU (nvidia-smi) ====="
if (Get-Command nvidia-smi -ErrorAction SilentlyContinue) { $t += (& nvidia-smi | Out-String) }
$t -join "`r`n" | Out-File -LiteralPath $raw -Encoding utf8

# Installed programs
$paths = @(
  'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
  'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
  'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
)
$apps = foreach ($p in $paths) {
  Get-ItemProperty $p | Where-Object { $_.DisplayName } |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, EstimatedSize
}
$apps = $apps | Sort-Object DisplayName -Unique
("Total installed programs: " + $apps.Count) | Set-Content -LiteralPath $programs -Encoding utf8
$apps | Format-Table DisplayName, DisplayVersion, Publisher -AutoSize |
  Out-String -Width 300 | Add-Content -LiteralPath $programs -Encoding utf8

# Embedded Python packages
if (Test-Path $py) { & $py -m pip freeze | Out-File -LiteralPath $pyPkgs -Encoding utf8 }

Write-Host "Baseline written to:"
Write-Host "  $raw"
Write-Host "  $programs"
Write-Host "  $pyPkgs"
Write-Host ("Admin: " + $isAdmin + " (TPM/BitLocker/Defender exclusions need admin)")
