param (
    [string[]]$Letters,  # List of letters to generate
    [string]$Font,       # Font to use
    [int]$Height,        # Height of the image
    [string]$OutputDir   # Output directory to save images
)

# Ensure ImageMagick is installed and the convert command is available
$magick = "magick"  # If ImageMagick's binary is installed as "magick"
$border_size = 1     # 1 pixel border to add to the right of each letter

# Extract font name for the output file naming
$fontName = [System.IO.Path]::GetFileNameWithoutExtension($Font)

# Create the output directory if it doesn't exist
if (-not (Test-Path $OutputDir)) {
    New-Item -Path $OutputDir -ItemType Directory
}

# Counter for the numbering in output filenames
$counter = 1

foreach ($letter in $Letters) {
    # Create a temporary image with the letter
    $temp_image = Join-Path $OutputDir "$counter-temp.png"
    $output_image = Join-Path $OutputDir "${fontName}_${counter}.png"

    # Generate the image using ImageMagick's convert command with transparent background and white letter
    $command = "$magick +antialias -background none -fill white -font $Font -pointsize $Height label:`"$letter`" $temp_image"
    Write-Host "Running command: $command"
    Invoke-Expression $command
    
    $image_height = & $magick identify -format "%h" $temp_image    

    # Auto-crop the image to remove any unnecessary space around the letter
    $command = "$magick $temp_image -trim -format ""%w"" info:"
    Write-Host "Running command: $command"
    $output = Invoke-Expression $command       
    $width, $temp = $output -split " "
    $final_width = [int]$width + $border_size

    $command = "$magick $temp_image -crop ${final_width}x${image_height}+0+0 $output_image"
    Write-Host "Running command: $command"
    Invoke-Expression $command           

    # Clean up the temporary files
    Remove-Item $temp_image

    # Increment the counter for the next file
    $counter++
}

Write-Host "Image generation complete. Check the $OutputDir for the output images."

#.\CreateFontSprites.ps1 -Letters 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '%', '$', '*', '#', '.', ',', ':', ';', '-', "'", "''", '<', '>', '/', '?', '!', '(', ')', '+', '=', '_', ' ' -Font "C:\\Users\\uersu\\AppData\\Local\\Microsoft\\Windows\\Fonts\\sierra-sci-menu-font.ttf" -Height 7 -OutputDir .\work
