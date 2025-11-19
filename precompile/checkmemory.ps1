param(
    [Parameter(Mandatory = $true)]
    [string]$Path  # Path to the binary file
)

# Read the entire file as raw bytes
[byte[]]$bytes = [System.IO.File]::ReadAllBytes($Path)

# Define the patterns as byte arrays (big-endian representation in the file)
[byte[]]$patternDEADBEEF = 0xDE,0xAD,0xBE,0xEF
[byte[]]$patternBEEFDEAD = 0xBE,0xEF,0xDE,0xAD

function Find-Pattern {
    param(
        [byte[]]$Data,
        [byte[]]$Pattern,
        [int]$StartIndex
    )

    # Simple naive search
    for ($i = $StartIndex; $i -le $Data.Length - $Pattern.Length; $i++) {
        $match = $true
        for ($j = 0; $j -lt $Pattern.Length; $j++) {
            if ($Data[$i + $j] -ne $Pattern[$j]) {
                $match = $false
                break
            }
        }
        if ($match) { return $i }
    }
    return -1
}

# --- Main logic implementing the described steps ---

$idx = 0  # current starting point for step 1

while ($idx -lt $bytes.Length) {

    # Step 1: Search for the occurrence of 0xDEADBEEF
    $posDE = Find-Pattern -Data $bytes -Pattern $patternDEADBEEF -StartIndex $idx
    if ($posDE -lt 0) {
        break  # no more DEADBEEF; we're done
    }

    # We now have a DEADBEEF at $posDE.
    # According to steps 2-4, we enter a loop where we look for BEEFDEAD or DEADBEEF.
    # Step 2: Search for 0xBEEFDEAD or 0xDEADBEEF (from this DEADBEEF onward)
    $searchStart = $posDE + 4

    while ($true) {
        $nextDE = Find-Pattern -Data $bytes -Pattern $patternDEADBEEF -StartIndex $searchStart
        $nextBE = Find-Pattern -Data $bytes -Pattern $patternBEEFDEAD -StartIndex $searchStart

        # If neither is found, we're done with the file.
        if ($nextDE -lt 0 -and $nextBE -lt 0) {
            $idx = $bytes.Length
            break
        }

        # Decide which pattern comes first (if both exist)
        if ($nextBE -lt 0 -or ($nextDE -ge 0 -and $nextDE -lt $nextBE)) {
            # Step 3: 0xDEADBEEF is found first
            # Give out the position and continue with step 2 (keep looking for BE/DE or DE/AD)
            Write-Output ("0xDEADBEEF found at offset {0} (0x{0:X})" -f $nextDE)

            # Continue searching after this DEADBEEF
            $searchStart = $nextDE + $patternDEADBEEF.Length
        }
        else {
            # Step 4: 0xBEEFDEAD is found first
            # Continue with step 1: restart search for DEADBEEF after this BEEFDEAD
            $idx = $nextBE + $patternBEEFDEAD.Length
            break
        }
    }
}
