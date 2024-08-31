param (
    [string]$SourceDir,         # Source directory with PNG files
    [string]$DestinationPrefix, # Prefix for the output files
    [string]$DestinationDir    # Directory for output files
)

# Ensure destination directory exists
if (-not (Test-Path $DestinationDir)) {
    New-Item -ItemType Directory -Path $DestinationDir | Out-Null
}

# Create a palette image in the ImageMagick TXT format
$palettePath = Join-Path $DestinationDir "palette.txt"
$paletteTxt = "*magick\n"
for ($i = 0; $i -lt $paletteColors.Length; $i++) {
    $paletteTxt += "${i}: {$paletteColors[$i]}  srgb(0,0,0)\n"
}
$paletteTxt | Set-Content -Path $palettePath

# Function to process an image
function Process-Image {
    param (
        [string]$FilePath,
        [string]$OutputPathPng,
        [string]$OutputPathTga,
        [string]$PaletteFileName
    )

    # Trim the image, ensure the width is a multiple of 16, and apply the custom palette
    $tempPath = [System.IO.Path]::GetTempFileName()

    & magick convert $FilePath -trim $tempPath

    # Get dimensions to ensure width is a multiple of 16
    $dimensions = & magick identify -format "%wx%h" $tempPath
    $width, $height = $dimensions -split "x"

    if ($width % 16 -ne 0) {
        $newWidth = [math]::Ceiling($w
        idth / 16) * 16
        & magick convert $tempPath -background none -gravity center -extent ${newWidth}x$height $tempPath
    }

    # Apply the custom palette and save in PNG and TGA formats
    & gm.exe convert $tempPath -remap $PaletteFileName $OutputPathPng
    & magick convert $OutputPathPng $OutputPathTga

    # Cleanup
    Remove-Item $tempPath
}

# Iterate over all PNG files in the source directory
$pngFiles = Get-ChildItem -Path $SourceDir -Filter *.png

$counter = 0
foreach ($file in $pngFiles) {
    $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $outputFileName = "$DestinationPrefix" + "_" + $counter
    $palettefileName = Join-Path -Path $DestinationDir -ChildPath "palette.png"

    $outputPathPng = Join-Path -Path $DestinationDir -ChildPath "$outputFileName.png"
    $outputPathTga = Join-Path -Path $DestinationDir -ChildPath "$outputFileName.tga"

    Process-Image -FilePath $file.FullName -OutputPathPng $outputPathPng -OutputPathTga $outputPathTga -PaletteFileName $palettefileName 

    $counter++
}

# Cleanup the palette file
Remove-Item $palettePath
