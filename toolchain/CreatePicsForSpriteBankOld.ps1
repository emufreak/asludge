param (
    [string]$SourceDir,         # Source directory with PNG files
    [string]$DestinationPrefix, # Prefix for the output files
    [string]$DestinationDir     # Directory for output files
)

# Load necessary assemblies
Add-Type -AssemblyName System.Drawing

# Ensure destination directory exists
if (-not (Test-Path $DestinationDir)) {
    New-Item -ItemType Directory -Path $DestinationDir | Out-Null
}

# Predefined 32 color palette (Example)
$targetpalette = @(
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255), # Color 0 is transparent (00ffff)
    [System.Drawing.Color]::FromArgb(0, 0, 0, 0),
    [System.Drawing.Color]::FromArgb(0, 0xaa, 0, 0),
    [System.Drawing.Color]::FromArgb(0, 0xaa, 0, 0xaa),
    [System.Drawing.Color]::FromArgb(0, 0xaa, 0, 0xaa),
    [System.Drawing.Color]::FromArgb(0, 0x55, 0x55, 0x55),
    [System.Drawing.Color]::FromArgb(0, 0xaa, 0x55, 0x00),
    [System.Drawing.Color]::FromArgb(0, 0x00, 0xaa, 0x00),
    [System.Drawing.Color]::FromArgb(0, 0xff, 0x55, 0x55),
    [System.Drawing.Color]::FromArgb(0, 0x00, 0xaa, 0x00),
    [System.Drawing.Color]::FromArgb(0, 0x00, 0xaa, 0xaa),
    [System.Drawing.Color]::FromArgb(0, 0xaa, 0xaa, 0xaa),
    [System.Drawing.Color]::FromArgb(0, 0x55, 0xff, 0x55),
    [System.Drawing.Color]::FromArgb(0, 0x55, 0xff, 0xff),
    [System.Drawing.Color]::FromArgb(0, 0xff, 0xff, 0x55),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255),
    [System.Drawing.Color]::FromArgb(0, 0, 255, 255)
)

# Function to apply palette and resize the image
# Function to apply palette and resize the image
function Process-Image {
    param (
        [string]$FilePath,
        [string]$OutputPathPng,
        [string]$OutputPathTga
    )

    # Load image
    $bitmap = [System.Drawing.Image]::FromFile($FilePath)
    $width = $bitmap.Width
    $height = $bitmap.Height

    # Convert the image to a format that supports a palette
    $newBitmap = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format8bppIndexed)

    # Set the custom palette
    $palette = $newBitmap.Palette
    for ($i = 0; $i -lt $targetpalette.Count; $i++) {
        $palette.Entries[$i] = $targetpalette[$i]
    }
    $newBitmap.Palette = $palette

    # Copy the image data and match colors to the palette
    $graphics = [System.Drawing.Graphics]::FromImage($newBitmap)
    $graphics.DrawImage($bitmap, [System.Drawing.Rectangle]::FromLTRB(0, 0, $width, $height))

    # Save the new image in both PNG and TGA formats
    $newBitmap.Save($OutputPathPng, [System.Drawing.Imaging.ImageFormat]::Png)
    $newBitmap.Save($OutputPathTga, [System.Drawing.Imaging.ImageFormat]::Tga)

    # Clean up
    $graphics.Dispose()
    $newBitmap.Dispose()
    $bitmap.Dispose()
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
