# collect_system_baseline_admin.ps1
# ADMIN-GATED portion of the system baseline (TPM, BitLocker, Defender, boot config).
# Read-only. Run in an ELEVATED PowerShell window.
#
# Usage (elevated):
#   pwsh -NoProfile -ExecutionPolicy Bypass -File .\collect_system_baseline_admin.ps1

$ErrorActionPreference = 'SilentlyContinue'
$root = $PSScriptRoot
$logs = Join-Path $root 'work\logs'
New-Item -ItemType Directory -Path $logs -Force | Out-Null
$out  = Join-Path $logs 'system_baseline_admin.txt'

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$t = @()
$t += "# Admin-gated system baseline  $(Get-Date -Format 'u')"
$t += "Running as Administrator: $isAdmin"
if (-not $isAdmin) { $t += "!! NOT ELEVATED - results will be incomplete. Re-run as Administrator." }
$t += ""

$t += "===== TPM (Get-Tpm) ====="
$t += (Get-Tpm | Format-List * | Out-String)
$t += "===== TPM Endorsement Key ====="
$t += (Get-TpmEndorsementKeyInfo -Hash SHA256 | Format-List * | Out-String)

$t += "===== TPM (WMI Win32_Tpm) ====="
$t += (Get-CimInstance -Namespace root/cimv2/security/microsofttpm -Class Win32_Tpm | Format-List * | Out-String)

$t += "===== BitLocker (Get-BitLockerVolume) ====="
$t += (Get-BitLockerVolume | Format-List * | Out-String)
$t += "===== BitLocker (manage-bde -status) ====="
$t += (manage-bde -status | Out-String)

$t += "===== Defender Status (full) ====="
$t += (Get-MpComputerStatus | Format-List * | Out-String)
$t += "===== Defender Preferences (key) ====="
$t += (Get-MpPreference | Format-List ExclusionPath,ExclusionExtension,ExclusionProcess,ExclusionIpAddress,DisableRealtimeMonitoring,DisableBehaviorMonitoring,DisableIOAVProtection,DisableScriptScanning,EnableControlledFolderAccess,AttackSurfaceReductionRules_Ids,MAPSReporting,SubmitSamplesConsent | Out-String)

$t += "===== Boot configuration (bcdedit) ====="
$t += (bcdedit /enum all | Out-String)

$t += "===== Secure Boot (Confirm-SecureBootUEFI) ====="
$t += ("Confirm-SecureBootUEFI: " + (Confirm-SecureBootUEFI))
$t += ("Get-SecureBootUEFI PK: " + (Get-SecureBootUEFI -Name PK | Out-String))

$t += "===== Secure Boot policy (Get-SecureBootPolicy) ====="
$t += (Get-SecureBootPolicy | Out-String)

$t += "===== Boot order / firmware (Get-CimInstance Win32_SystemBootConfiguration) ====="
$t += (Get-CimInstance Win32_SystemBootConfiguration | Format-List * | Out-String)

$t += "===== Storage reliability (SMART) ====="
$t += (Get-PhysicalDisk | ForEach-Object {
        $d = $_
        $rel = $d | Get-StorageReliabilityCounter
        "[$($d.DeviceId)] $($d.FriendlyName)"
        ($rel | Format-List * | Out-String)
      }) -join "`r`n"

$t += "===== Windows activation ====="
$t += (Get-CimInstance SoftwareLicensingProduct | Where-Object { $_.PartialProductKey -and $_.ApplicationID -eq '55c92734-d682-4d71-983e-d6ec3f16059f' } | Format-List Name,Description,LicenseStatus,PartialProductKey | Out-String)

$t -join "`r`n" | Out-File -LiteralPath $out -Encoding utf8
Write-Host ""
Write-Host "Admin baseline written to: $out"
Write-Host ("Admin: " + $isAdmin)
Start-Sleep -Seconds 2
