param(
  [string]$Code = "",
  [string[]]$ExtraArgs = @()
)
$q = "C:\Users\Ghost\Desktop\bestproject\tools\qemu"
$w = "C:\Users\Ghost\Desktop\bestproject\work\qemu"
if ([string]::IsNullOrEmpty($Code)) { $Code = "$q\share\edk2-x86_64-code.fd" }
$args = @(
  "-m", "1024",
  "-machine", "q35",
  "-display", "none",
  "-serial", "stdio",
  "-monitor", "none",
  "-no-reboot",
  "-drive", "if=pflash,format=raw,unit=0,readonly=on,file=$Code",
  "-drive", "if=pflash,format=raw,unit=1,file=$w\vars.fd"
)
if (Test-Path "$w\esp") {
  $args += @("-drive", "file=fat:rw:$w\esp,format=raw,if=ide,index=0")
}
$args += $ExtraArgs
& "$q\qemu-system-x86_64.exe" @args
