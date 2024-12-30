# PowerShell script to extract the letter 'a' from an image containing black and white text

# Set paths for Tesseract OCR and image input/output
$tesseractPath = "C:\\Program Files\\Tesseract-OCR\\tesseract.exe"
$imagePath = "SierraSansFont.png"
$outputPath = "extracted_a.png"

# Check if Tesseract OCR is installed
if (!(Test-Path $tesseractPath)) {
    Write-Error "Tesseract OCR is not installed or the path is incorrect."
    exit 1
}

# Ensure the necessary tools are installed
if (!(Get-Command magick -ErrorAction SilentlyContinue)) {
    Write-Error "ImageMagick is not installed. Please install it to proceed."
    exit 1
}

# Step 1: Convert the image to binary using ImageMagick
$binaryImagePath = "temp.png"
magick $imagePath -threshold 50% $binaryImagePath

# Step 2: Extract the letter 'a' using Tesseract OCR
$customConfig = "--oem 3 --psm 6 -c tessedit_char_whitelist=a"
$rawOutput = & $tesseractPath $binaryImagePath stdout -c $customConfig

# Step 3: Process contours to extract 'a'
$maskImagePath = "C:\\path\\to\\temp_mask.png"
magick convert $binaryImagePath -morphology Open Diamond -fill white $maskImagePath

# Step 4: Save the output
generate detailed trim api user