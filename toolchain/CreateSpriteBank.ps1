param (
    [string]$filename,
    [int]$xhot = 0,
    [int]$yhot = 0,    
    [ValidateSet('mouse','bob', 'font')]
    [string]$type = "bob"
)

switch -Exact ($type)
{
    'mouse' { $typenr = 1 }
    'bob' { $typenr = 2 }
    'font' { $typenr = 3 }
}

Remove-Item .\header.bin

$spritenum = (Get-ChildItem ".\${filename}*.png" | Measure-Object ).Count

$header = [Byte[]] (0x00, 0x00, $typenr, 0x00, $spritenum)
Add-Content -Path ".\header.bin" -Value $header -Encoding Byte
Copy-Item header.bin source.aduc

# Attach Items
Add-Type -AssemblyName System.Drawing
for($i = 1; $i -le $spritenum; $i++) {
    # Add Header for Item
    $path = Get-Location
    $fullpathimage = "${path}\${filename}_${i}.png"
    $image = [System.Drawing.Image]::FromFile("$fullpathimage")
    $headerwidth = $image.Width

    if($type -eq 'font') {
        $lastColumn = magick $fullpathimage -crop 1x${image.Height}+$($image.Width - 1)+0 txt:-
        if($lastColumn -match 'gray\(255\)|graya\(255|srgb\(255,255,255\)|srgba\(255,255,255|rgb\(255,255,255\)|rgba\(255,255,255') {
            $headerwidth += 1
        }
    }

    $headeritem = [Byte[]] (0x00, $headerwidth, 0x00, $image.Height, 0x00, $xhot, 0x00, $yhot)
    Add-Content -Encoding Byte -Path source.aduc -Value $headeritem 

    # Add Data
    switch -Exact ($type)
    {
        'mouse' 
        { 
            if($image.Width % 16 -ne 0) {
                Write-Error "Sprite must be a multiple of 16 pixel wide"
                return 1;
            }
            .\amigeconv.exe --format sprite --depth 2 --width 16 --controlword $fullpathimage "${filename}_${i}.SPR"        

            Get-Content -Encoding Byte -Path source.aduc, "${filename}_${i}.SPR" | Set-Content -Encoding Byte target.aduc
            Remove-Item "${filename}_${i}.SPR"
        }
        'bob' 
        { 
            if($image.Width % 16 -ne 0) {
                Write-Error "Bob must be a multiple of 16 pixel wide"
                return 1;
            }
                
            .\amigeconv.exe --format bitplane --depth 5 --width 16 $fullpathimage "${filename}_${i}.BPL"        
            .\amigeconv.exe --format bitplane --depth 5 --width 16 --mask inverted --controlword $fullpathimage "${filename}_${i}_mask.BPL"        
            [byte[]](Get-Content "${filename}_${i}_mask.BPL" -Encoding Byte | ForEach {$_ -bxor 0xFF })| Set-Content "${filename}_${i}_mask2.BPL" -Encoding Byte
            Get-Content -Encoding Byte -Path "${filename}_${i}.BPL", "${filename}_${i}_mask2.BPL" | Set-Content -Encoding Byte "${filename}_${i}_final.BPL"
            Get-Content -Encoding Byte -Path source.aduc, "${filename}_${i}_final.BPL" | Set-Content -Encoding Byte target.aduc
            Remove-Item "${filename}_${i}*.BPL" 
        }
        'font' 
        {
            if($image.Width % 16 -ne 0) {
                $newwidth = [math]::floor(($image.Width / 16) + 1) * 16
                magick $fullpathimage -extent ${newwidth}x${image.Height} PNG8:"tmp.png"
            }
            else
            {
                cp $fullpathimage tmp.png
            }

            $pixel = magick $fullpathimage -format "%[pixel:p{0,0}]" info:
            if($pixel -eq "graya(255,1)") {
                .\amigeconv.exe -f bitplane -m inverted tmp.png "${filename}_${i}.BPL"
            }
            else
            {
                .\amigeconv.exe --format bitplane --depth 1 tmp.png "${filename}_${i}.BPL"
            }            
            Get-Content -Encoding Byte -Path source.aduc, "${filename}_${i}.BPL" | Set-Content -Encoding Byte target.aduc
            Remove-Item "${filename}_${i}.BPL"
            Remove-Item tmp.png
        }
    }    

    # Prepare and Cleanup
    Copy-Item target.aduc source.aduc
    
}

Copy-Item target.aduc "${filename}.aduc"

Remove-Item .\header.bin
Remove-Item target.aduc
Remove-Item source.aduc

