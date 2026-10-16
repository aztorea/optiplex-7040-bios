$q = "C:\Users\Ghost\Desktop\bestproject\tools\qemu\qemu-system-x86_64.exe"
$w = "C:\Users\Ghost\Desktop\bestproject\work\qemu"
$img = "$w\dell_bios8.fd"
Remove-Item "$w\dell_shot.ppm" -ErrorAction SilentlyContinue

$qargs = @(
  "-m","4096","-machine","q35","-cpu","Skylake-Client","-smp","1",
  "-display","none","-vga","std",
  "-serial","null",
  "-monitor","tcp:127.0.0.1:4555,server,nowait",
  "-drive","if=pflash,format=raw,unit=0,readonly=on,file=$img"
)
$proc = Start-Process -FilePath $q -ArgumentList $qargs -PassThru -RedirectStandardError "$w\probe2_err.txt" -RedirectStandardOutput "$w\probe2_out.txt"
Start-Sleep -Seconds 8
"qemu alive: " + (-not $proc.HasExited) + "  (pid " + $proc.Id + ")"
$report = ""
try {
  $c = New-Object Net.Sockets.TcpClient
  $c.Connect("127.0.0.1", 4555)
  $st = $c.GetStream(); $st.ReadTimeout = 2500
  $wtr = New-Object IO.StreamWriter($st); $wtr.AutoFlush = $true
  Start-Sleep -Milliseconds 400
  $wtr.WriteLine("info registers")
  $wtr.WriteLine("info status")
  $wtr.WriteLine("screendump $w\dell_shot.ppm")
  Start-Sleep -Milliseconds 1200
  $buf = New-Object byte[] 262144
  $sb = New-Object Text.StringBuilder
  try { while ($true) { $n = $st.Read($buf,0,$buf.Length); if ($n -le 0) { break }; [void]$sb.Append([Text.Encoding]::ASCII.GetString($buf,0,$n)) } } catch {}
  $report = $sb.ToString()
  $wtr.WriteLine("quit")
  Start-Sleep -Milliseconds 300
  $c.Close()
} catch { $report = "monitor failed: $_" }
Start-Sleep -Milliseconds 500
if (-not $proc.HasExited) { $proc.Kill() }
"---- monitor ----"
$report
"---- screendump ----"
if (Test-Path "$w\dell_shot.ppm") { "ppm bytes: " + (Get-Item "$w\dell_shot.ppm").Length } else { "no screendump" }
