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
for($i = 0; $i -lt $spritenum; $i++) {
    # Add Header for Item
    $path = Get-Location
    $fullpathimage = "${path}\${filename}_${i}.png"
    $image = [System.Drawing.Image]::FromFile("$fullpathimage")        

    # Add Data
    switch -Exact ($type)
    {
        'mouse' 
        { 
            $headeritem = [Byte[]] (0x00, $image.Width, 0x00, $image.Height, 0x00, $xhot, 0x00, $yhot)
            Add-Content -Encoding Byte -Path source.aduc -Value $headeritem 

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
            $headeritem = [Byte[]] (0x00, $image.Width, 0x00, $image.Height, 0x00, $xhot, 0x00, $yhot)
            Add-Content -Encoding Byte -Path source.aduc -Value $headeritem 


            if($image.Width % 16 -ne 0) {
                Write-Error "Bob must be a multiple of 16 pixel wide"
                return 1;
            }

            KingCon $fullpathimage "${filename}_${i}" -F=5 -M        
            Get-Content -Encoding Byte -Path source.aduc, "${filename}_${i}.BPL" | Set-Content -Encoding Byte target.aduc
            Remove-Item "${filename}_${i}.BPL" 
        }
        'font' 
        {
            $dimensions = magick $fullpathimage -trim -format "%w" info:
            $width, $temp = $dimensions -split " "
            
            if($width -eq 0) 
            {
                $width = 3
            }

            $headeritem = [Byte[]] (0x00, $Width, 0x00, $image.Height, 0x00, $xhot, 0x00, $yhot)
            Add-Content -Encoding Byte -Path source.aduc -Value $headeritem 


            if($image.Width % 16 -ne 0) {
                $newwidth = [math]::floor(($image.Width / 16) + 1) * 16
                magick $fullpathimage -colorspace RGB -extent ${newwidth}x${image.Height} PNG8:"tmp.png"
            }
            else
            {
                cp $fullpathimage tmp.png
            }

            .\amigeconv.exe -f bitplane -d 1 tmp.png tmp.BPL
            
            $image = [System.Drawing.Image]::FromFile("$pwd\tmp.png")                                                            
            $pixelcolor = $image.GetPixel(0,0)
            $image.Dispose()
            if($pixelcolor.R -eq 0)
            {
                [byte[]](Get-Content tmp.BPL -Encoding Byte| ForEach {$_ -bxor 0xFF })| Set-Content tmp2.BPL -Encoding Byte
                Get-Content -Encoding Byte -Path source.aduc, tmp2.BPL | Set-Content -Encoding Byte target.aduc
                Remove-Item tmp2.BPL
            } 
            else 
            {                  
                Get-Content -Encoding Byte -Path source.aduc, tmp.BPL | Set-Content -Encoding Byte target.aduc
            }
            
            Remove-Item tmp.BPL
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


