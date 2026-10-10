param(
  [string]$Src = "C:\Users\growp\Downloads\palawan (1)\2.png",
  [string]$Out = "C:\Users\growp\AppData\Local\Temp\opencode\coolify-brand"
)
Add-Type -AssemblyName System.Drawing
New-Item -ItemType Directory -Force -Path $Out | Out-Null
$img = [System.Drawing.Image]::FromFile($Src)
Write-Host "source: $($img.Width)x$($img.Height)"

# square-crop source into a bitmap (centered) so icons are not distorted
$min = [Math]::Min($img.Width, $img.Height)
$sx = [int](($img.Width - $min) / 2)
$sy = [int](($img.Height - $min) / 2)

$pngs = @()
foreach ($s in @(16, 32, 48, 256)) {
  $bmp = New-Object System.Drawing.Bitmap($s, $s)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.DrawImage($img, (New-Object System.Drawing.Rectangle(0,0,$s,$s)), (New-Object System.Drawing.Rectangle($sx,$sy,$min,$min)), [System.Drawing.GraphicsUnit]::Pixel)
  $g.Dispose()
  $ms = New-Object System.IO.MemoryStream
  $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  $pngs += ,@($s, $ms.ToArray())
  $ms.Dispose()
}

# build multi-size ICO (PNG-compressed entries)
$icoPath = Join-Path $Out "favicon.ico"
$fs = [System.IO.File]::Create($icoPath)
$bw = New-Object System.IO.BinaryWriter($fs)
$bw.Write([uint16]0)
$bw.Write([uint16]1)
$bw.Write([uint16]$pngs.Count)
$offset = 6 + (16 * $pngs.Count)
foreach ($e in $pngs) {
  $s = [int]$e[0]
  $d = [byte[]]$e[1]
  $dim = if ($s -ge 256) { 0 } else { $s }
  $bw.Write([byte]$dim)
  $bw.Write([byte]$dim)
  $bw.Write([byte]0)
  $bw.Write([byte]0)
  $bw.Write([uint16]1)
  $bw.Write([uint16]32)
  $bw.Write([uint32]$d.Length)
  $bw.Write([uint32]$offset)
  $offset += $d.Length
}
foreach ($e in $pngs) { $bw.Write([byte[]]$e[1]) }
$bw.Dispose()
$fs.Dispose()

# apple-touch-icon 180x180
$bmp = New-Object System.Drawing.Bitmap(180, 180)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.DrawImage($img, (New-Object System.Drawing.Rectangle(0,0,180,180)), (New-Object System.Drawing.Rectangle($sx,$sy,$min,$min)), [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$bmp.Save((Join-Path $Out "apple-touch-icon.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$img.Dispose()

Get-ChildItem $Out | Select-Object Name, Length
