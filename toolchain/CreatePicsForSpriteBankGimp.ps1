param (
    [string]$SourceDir,         # Source directory with PNG files
    [string]$DestinationPrefix, # Prefix for the output files
    [string]$DestinationDir     # Directory for output files
)

# Ensure destination directory exists
if (-not (Test-Path $DestinationDir)) {
    New-Item -ItemType Directory -Path $DestinationDir | Out-Null
}

# Define the custom 32-color palette as hex strings
$paletteColors = @(
    "(0 255 255 0)", # Transparent color
    "(0 0 0 0)",
    "(170 0 0 0)",
    "(170 0 170 0)",
    "(170 0 170 0)",
    "(85 85 85 0)",
    "(170 85 0 0)",
    "(0 170 0 0)",
    "(255 85 85 0)",
    "(0 170 0 0)",
    "(0 170 170 0)",
    "(170 170 170 0)",
    "(85 255 85 0)",
    "(85 255 255 0)",
    "(255 255 85 0)",
    "(0 255 255 0)",
    "(0 255 255 0)", # Repeated entries
    "(0 255 255 0)",
    "(0 255 255 0)",
    "(0 255 255 0)",
    "(0 255 255 0)",
    "(0 255 255 0)",
    "(0 255 255 0)",
    "(0 255 255 0)",
    "(0 255 255 0)",
    "(0 255 255 0)",
    "(0 255 255 0)",
    "(0 255 255 0)",
    "(0 255 255 0)",
    "(0 255 255 0)",
    "(0 255 255 0)"
)

# Create a GIMP palette file
$palettePath = Join-Path $DestinationDir "custom_palette.gpl"
$paletteTxt = "GIMP Palette\nName: Custom\nColumns: 0\n"
for ($i = 0; $i -lt $paletteColors.Length; $i++) {
    $color = $paletteColors[$i].Trim('(', ')').Replace(' ', '')
    $rgb = $color -split ','
    $paletteTxt += "$($rgb[0]) $($rgb[1]) $($rgb[2]) Color$i\n"
}
$paletteTxt | Set-Content -Path $palettePath

# Function to process an image
function Process-Image {
    param (
        [string]$FilePath,
        [string]$OutputPathPng,
        [string]$OutputPathTga
    )

    # Prepare the script for GIMP
    $script = @"
(define (process-image filename outputPng outputTga palette)
  (leta (
    (image (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
    (drawable (car (gimp-image-get-active-layer image)))
  )
    (gimp-image-lower-item-to-bottom image drawable)
    (gimp-layer-resize-to-image-size drawable)
    (gimp-image-crop-to-content image)
    (let* ((new-width (+ (* 16 (/ (+ (car (gimp-image-width image)) 15) 16)) 0))
           (new-height (car (gimp-image-height image))))
      (if (< (car (gimp-image-width image)) new-width)
        (gimp-image-resize image new-width new-height 0 0))
    )
    (gimp-image-convert-indexed image 0 0 32 0 1 "")
    (gimp-palette-set-colors palette)
    (gimp-file-save RUN-NONINTERACTIVE image drawable outputPng outputPng)
    (gimp-image-convert-rgb image)
    (gimp-file-save RUN-NONINTERACTIVE image drawable outputTga outputTga)
    (gimp-image-delete image)
  )
)
"@

    $scriptFile = [System.IO.Path]::GetTempFileName() + ".scm"
    Set-Content -Path $scriptFile -Value $script

    # Run GIMP in batch mode
    & "C:\Program Files\GIMP 2\bin\gimp-console-2.10.exe" -i -b "(process-image \"$FilePath\" \"$OutputPathPng\" \"$OutputPathTga\" \"$palettePath\")" -b "(gimp-quit 0)"

    # Cleanup
    Remove-Item $scriptFile
}

# Iterate over all PNG files in the source directory
$pngFiles = Get-ChildItem -Path $SourceDir -Filter *.png

$counter = 0
foreach ($file in $pngFiles) {
    $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $outputFileName = "$DestinationPrefix" + "_" + $counter

    $outputPathPng = Join-Path -Path $DestinationDir -ChildPath "$outputFileName.png"
    $outputPathTga = Join-Path -Path $DestinationDir -ChildPath "$outputFileName.tga"

    Process-Image -FilePath $file.FullName -OutputPathPng $outputPathPng -OutputPathTga $outputPathTga

    $counter++
}

# Cleanup the palette file
Remove-Item $palettePath
