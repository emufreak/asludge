param(
    [string]$inputFileName,
    [array]$paramsArray # Array containing width, height, startX, startY, y for each file
)

# Function to add 2-byte integer to the byte stream

function Add-ByteInt {
    param (
        [int]$value,
        [ref]$byteStream
    )
    # Convert integer to 2 bytes and add to byte stream
    $bytes = [BitConverter]::GetBytes([int16]$value)    
    Add-Content -Encoding Byte -Path $outputBinaryFile -Value $bytes[0]
}

function Add-TwoByteInt {
    param (
        [int]$value,
        [ref]$byteStream
    )
    # Convert integer to 2 bytes and add to byte stream
    $bytes = [BitConverter]::GetBytes([int16]$value)
    Add-Content -Encoding Byte -Path $outputBinaryFile -Value $bytes[1] 
    Add-Content -Encoding Byte -Path $outputBinaryFile -Value $bytes[0]
}

$counter = 0
# Write the final byte stream to a binary file
$outputBinaryFile = "output_binary_file.bin"
Remove-Item $outputBinaryFile

# Convert the mask to bitplane format using amigeconv
$outputFileName = "outputfile_$counter.bpl"


# Initialize the byte stream starting with "aszb"
$byteStream = [Byte[]] ([System.Text.Encoding]::ASCII.GetBytes("aszb"))
Add-Content -Encoding Byte -Path $outputBinaryFile -Value $byteStream 

# Loop through all matching files in the directory

$count = (Get-ChildItem -Path . -Filter "$inputFileName*.png").Count

Add-ByteInt -value $count -byteStream ([ref]$byteStream)

Get-ChildItem -Path . -Filter "$inputFileName*.png" | ForEach-Object -Process {
    $file = $_

    # Ensure we have corresponding parameter values
    if ($paramsArray.Length -lt ($counter * 4 + 4)) {
        Write-Host "Insufficient parameters for file $file, skipping..."
        return
    }

    # Retrieve width, height, startX, startY for the current file

    $width = [int]$paramsArray[$counter * 5]
    $height = [int]$paramsArray[$counter * 5 + 1]
    $startX = [int]$paramsArray[$counter * 5 + 2]
    $startY = [int]$paramsArray[$counter * 5 + 3]
    $yz = [int]$paramsArray[$counter * 5 + 4]

    # Add width, height, startX, and startY to the byte stream
    Add-TwoByteInt -value $width -byteStream ([ref]$byteStream)
    Add-TwoByteInt -value $height -byteStream ([ref]$byteStream)
    Add-TwoByteInt -value $startX -byteStream ([ref]$byteStream)
    Add-TwoByteInt -value $startY -byteStream ([ref]$byteStream)
    Add-TwoByteInt -value $yz -byteStream ([ref]$byteStream)

    amigeconv --format bitplane --depth 1 $file.FullName $outputFileName

    # Add contents of the output .bpl file to the byte stream    
    $outputBytes = [System.IO.File]::ReadAllBytes("$PWD\$outputFileName")
    Add-Content -Encoding Byte -Path $outputBinaryFile -Value $outputBytes

    # Increment counter for next file
    $counter++
}

Write-Host "Binary file $outputBinaryFile created successfully."
