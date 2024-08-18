﻿param (
    [string]$filename,
    [int]$xhot = 0,
    [int]$yhot = 0,    
    [ValidateSet('mouse','bob')]
    [string]$type = "bob"
)

if($type -eq "mouse") {
  $typenr = 1
} else {
  $typenr = 2
}

Remove-Item .\header.bin

$spritenum = (Get-ChildItem ".\${filename}*.png" | Measure-Object ).Count

$header = [Byte[]] (0x00, 0x00, $typenr, 0x00, $spritenum)
Add-Content -Path ".\header.bin" -Value $header -Encoding Byte
Copy-Item header.bin source.aduc

# Attach Items
Add-Type -AssemblyName System.Drawing
for($i = 0; $i -lt $spritenum; $i++) {
    # Add Header for Item
    $path = Get-Location
    $fullpathimage = "${path}\${filename}_${i}.png"
    $image = [System.Drawing.Image]::FromFile("$fullpathimage")
    $headeritem = [Byte[]] (0x00, $image.Width, 0x00, $image.Height, 0x00, $xhot, 0x00, $yhot)
    Add-Content -Encoding Byte -Path source.aduc -Value $headeritem 

    # Add Data
    if($type -eq "mouse") {
        amigeconv --format sprite --depth 2 --width 16 --controlword $fullpathimage "${filename}_${i}.SPR"        
        Get-Content -Encoding Byte -Path source.aduc, "${filename}_${i}.SPR" | Set-Content -Encoding Byte target.aduc
        Remove-Item "${filename}_${i}.SPR"
    } else {
        KingCon $fullpathimage "${filename}_${i}" -F=5 -M        
        Get-Content -Encoding Byte -Path source.aduc, "${filename}_${i}.BPL" | Set-Content -Encoding Byte target.aduc
        Remove-Item "${filename}_${i}.BPL"
    }    
    

    # Prepare and Cleanup
    Copy-Item target.aduc source.aduc
    
}

Copy-Item target.aduc "${filename}.aduc"

Remove-Item .\header.bin
Remove-Item target.aduc
Remove-Item source.aduc


