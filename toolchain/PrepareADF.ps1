# Define variables
$adfFileName = "asludge.adf"
$adfFilePath = "C:\Users\uersu\Documents\GitData\asludge\toolchain\asludge.adf"
$usbDrivePath = "E:\OwnProds"

# Function to create ADF file from a directory using xdftool
function Create-AdfFile($adfFile) {
    $toolPath = "C:\Users\uersu\Documents\GitData\asludge\toolchain\CopyToAdf.exe" # Path to xdftool executable
    if (-Not (Test-Path $toolPath)) {
        Write-Error "CopyToAdf not found at $toolPath"
        return
    }

    # Create a blank ADF file
    #& $xdftoolPath $adfFile "create" "ffs" 880 || return $false

    # Copy the contents of the source directory to the ADF file
    & $toolPath "C:\Users\uersu\Documents\GitData\asludge\out\a.exe" $adfFile     
    & $toolPath "C:\Users\uersu\Documents\GitData\asludge\out\game\gamedata.slg" $adfFile game     

    Write-Output "ADF file created successfully at $adfFile"
    return $true
}

# Create ADF file
if (Create-AdfFile -adfFile $adfFilePath) {
    # Copy ADF file to USB stick
    try {
        Copy-Item -Path $adfFilePath -Destination $usbDrivePath -Force
        Write-Output "ADF file copied to USB stick successfully."

    } catch {
        Write-Error "Error occurred: $_"
    }
} else {
    Write-Error "ADF file creation failed. Script will not continue."
}
