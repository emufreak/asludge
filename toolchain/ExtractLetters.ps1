param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile,                       # Path to your input PNG file

    [Parameter(Mandatory=$true)]
    [string]$OutputFolder,                    # Where to store output letter images

    [Parameter(Mandatory=$true)]
    [int]$StartX,                             # Horizontal coordinate at which to start processing

    [Parameter(Mandatory=$true)]
    [int]$LineHeight,                         # The fixed height for each text line

    [Parameter(Mandatory=$true)]
    [int]$NumberOfLines,                      # How many lines of text to process

    [switch]$VerboseOutput                    # If set, additional logging is displayed
)

# Ensure output folder exists
if (!(Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

# 1) Get overall image width/height using ImageMagick "identify"
if ($VerboseOutput) { Write-Host "Retrieving image dimensions..." }
$imageDimensions = magick identify -format "%w %h" $InputFile
$imageWidth, $imageHeight = $imageDimensions -split "\s+" | ForEach-Object { [int]$_ }

if ($VerboseOutput) {
    Write-Host "Image width: $imageWidth"
    Write-Host "Image height: $imageHeight"
}

# 2) For each line, crop the relevant horizontal + vertical slice out, then detect letters
for ($lineIndex = 0; $lineIndex -lt $NumberOfLines; $lineIndex++) {

    # Calculate vertical offset for this line
    $topY = $lineIndex * $LineHeight

    # If the bottom of this line is outside the image, break early
    if ($topY -ge $imageHeight) {
        Write-Warning "Line index $lineIndex is outside image bounds. Stopping."
        break
    }

    # The crop region:
    #   width:  from StartX to right edge of the image
    #   height: fixed ($LineHeight)
    #   offset: +$StartX+$topY
    $cropWidth  = $imageWidth - $StartX
    $cropHeight = $LineHeight

    # Path to temporary line image
    $tempLineImage = Join-Path $OutputFolder ("line_$($lineIndex).png")

    if ($VerboseOutput) {
        Write-Host ("Cropping line $($lineIndex) into: $tempLineImage")
    }

    # Perform the crop for just this line
    magick `
        "$InputFile" `
        -crop "$($cropWidth)x$($cropHeight)+$($StartX)+$($topY)" `
        "$tempLineImage"

    # 3) Use connected-components to identify letter bounding boxes.
    #    - The verbose info from connected-components can be parsed to get bounding boxes.
    #
    #    We'll do a small trick: convert to grayscale/threshold so text is black and background is white.
    #    For example, you might do something like -threshold 50% or -alpha extract, depending on your image.
    #
    #    The -define connected-components:verbose=true outputs bounding-box lines to stdout, which
    #    we can capture in PowerShell and parse. Each component line typically looks like:
    #       "label: 1 area: 123 mean rgb: (......) bounding-box: 10x15+5+2"
    #
    #    We'll skip label 0 which typically is the background. Then each subsequent label is presumably a letter.

    if ($VerboseOutput) {
        Write-Host "Analyzing connected components for line $($lineIndex)..."
    }

    $ccOutput = magick `
        "$tempLineImage" `
        -alpha extract `
        -threshold 50% `
        -define connected-components:verbose=true `
        -define connected-components:mean-color=true `
        -connected-components 4 `
        null:

    # 4) Parse bounding-box info from $ccOutput
    #    We'll look for lines like:  label: 1 area: 500 mean color: (....) bounding-box: 30x50+10+20
    #    This quick pattern match extracts "WxH+X+Y" from bounding-box attribute.
    #
    #    Note: This might need adjusting if your IM version outputs differently.

    $boundingBoxes = @()
    foreach ($line in $ccOutput) {
        if ($line -match 'label: (\d+).*bounding-box: (\d+x\d+\+\d+\+\d+)') {
            $label   = $Matches[1]
            $bboxStr = $Matches[2]

            # label 0 is typically the background
            if ($label -ne "0") {
                $boundingBoxes += $bboxStr
            }
        }
    }

    if ($VerboseOutput) {
        Write-Host "Found $($boundingBoxes.Count) connected component(s) in line $($lineIndex)."
    }

    # 5) For each bounding box, crop out the letter.
    #    We'll store them in $OutputFolder\line_lineIndex_letter_XX.png
    $letterCount = 0
    foreach ($bbox in $boundingBoxes) {
        # The bounding-box format is something like "30x50+10+20"
        # We'll name the output files in ascending order.
        $outLetterFile = Join-Path $OutputFolder ("line_$($lineIndex)_letter_$($letterCount).png")

        if ($VerboseOutput) {
            Write-Host "Cropping letter bounding box '$bbox' to $outLetterFile"
        }

        magick `
            "$tempLineImage" `
            -crop $bbox `
            +repage `
            "$outLetterFile"

        $letterCount++
    }

    # (Optional) Remove temp line image if you don’t need it anymore
    # Remove-Item $tempLineImage
}

Write-Host "Done. Letters have been extracted to '$OutputFolder'."
