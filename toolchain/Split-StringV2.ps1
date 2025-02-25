# Define character width mapping
$charWidths = New-Object System.Collections.Hashtable

$charWidths['a'] = 6
$charWidths['b'] = 6
$charWidths['c'] = 5
$charWidths['d'] = 6
$charWidths['e'] = 5
$charWidths['f'] = 5
$charWidths['g'] = 6
$charWidths['h'] = 7
$charWidths['i'] = 4
$charWidths['j'] = 3
$charWidths['k'] = 7
$charWidths['l'] = 4
$charWidths['m'] = 10
$charWidths['n'] = 8
$charWidths['o'] = 6
$charWidths['p'] = 6
$charWidths['q'] = 6
$charWidths['r'] = 5
$charWidths['s'] = 5
$charWidths['t'] = 4
$charWidths['u'] = 7
$charWidths['v'] = 6
$charWidths['w'] = 10
$charWidths['x'] = 6
$charWidths['y'] = 8
$charWidths['z'] = 5
$charWidths['A'] = 8
$charWidths['B'] = 7
$charWidths['C'] = 8
$charWidths['D'] = 8
$charWidths['E'] = 7
$charWidths['F'] = 7
$charWidths['G'] = 9
$charWidths['H'] = 9
$charWidths['I'] = 4
$charWidths['J'] = 6
$charWidths['K'] = 9
$charWidths['L'] = 7
$charWidths['M'] = 10
$charWidths['N'] = 9
$charWidths['O'] = 8
$charWidths['P'] = 7
$charWidths['Q'] = 8
$charWidths['R'] = 8
$charWidths['S'] = 6
$charWidths['T'] = 8
$charWidths['U'] = 8
$charWidths['V'] = 8
$charWidths['W'] = 12
$charWidths['X'] = 9
$charWidths['Y'] = 8
$charWidths['Z'] = 7
$charWidths['0'] = 7
$charWidths['1'] = 5
$charWidths['2'] = 6
$charWidths['3'] = 6
$charWidths['4'] = 6
$charWidths['5'] = 6
$charWidths['6'] = 6
$charWidths['7'] = 6
$charWidths['8'] = 6
$charWidths['9'] = 6
$charWidths['percent'] = 11
$charWidths['dollar'] = 6
$charWidths['asterisk'] = 4
$charWidths['hash'] = 7
$charWidths['period'] = 2
$charWidths['comma'] = 3
$charWidths['colon'] = 2
$charWidths['semicolon'] = 3
$charWidths['hyphen'] = 6
$charWidths['apostrophe'] = 3
$charWidths['quotation'] = 4
$charWidths['less_than'] = 6
$charWidths['greater_than'] = 6
$charWidths['slash'] = 9
$charWidths['question'] = 6
$charWidths['exclamation'] = 2
$charWidths['left_parenthesis'] = 4
$charWidths['right_parenthesis'] = 4
$charWidths['plus'] = 6
$charWidths['equal'] = 7
$charWidths['underscore'] = 7
$charWidths['space'] = 5  # Space character

# Function to split input string into substrings with width below 176 while keeping words intact
function Split-StringByWidth {
    param (
        [string]$inputString,
        [int]$maxWidth = 176
    )
    
    $currentWidth = 0
    $currentString = ""
    $result = @()
    $words = $inputString -split ' '
    
    foreach ($word in $words) {
        $wordWidth = 0
        foreach ($char in $word.ToCharArray()) {
            $charKey = $char
            switch ($char) {
                '%' { $charKey = 'percent'}
                '$' { $charKey = 'dollar'}
                '*' { $charKey = 'asterisk'}
                '#' { $charKey = 'hash'}
                '.' { $charKey = 'period'}
                ',' { $charKey = 'comma'}
                ':' { $charKey = 'colon'}
                ';' { $charKey = 'semicolon'}
                '-' { $charKey = 'hyphen'}
                "'" { $charKey = 'apostrophe'}
                '"' { $charKey = 'quotation'}
                '<' { $charKey = 'less_than'}
                '>' { $charKey = 'greater_than'}
                '/' { $charKey = 'slash'}
                '?' { $charKey = 'question'}
                '!' { $charKey = 'exclamation'}
                '(' { $charKey = 'left_parenthesis'}
                ')' { $charKey = 'right_parenthesis'}
                '+' { $charKey = 'plus'}
                '=' { $charKey = 'equal'}
                '_' { $charKey = 'underscore'}
            }
            $wordWidth += $charWidths[$charKey.ToString()]
        }
        
        if (($currentWidth + $wordWidth) -gt $maxWidth) {
            $result += $currentString.Trim()
            $currentString = ""
            $currentWidth = 0
        }
        
        $currentString += $word + " "
        $currentWidth += $wordWidth + $charWidths['space']
    }
    
    if ($currentString -ne "") {
        $result += $currentString.Trim() + "`n"
    }
    
    return $result
}

# Get user input
$inputString = Read-Host "Enter a string to calculate width"

# Split string into chunks
$splitStrings = Split-StringByWidth -inputString $inputString

# Display results
Write-Host "Split strings:"
$splitStrings | ForEach-Object { Write-Host $_ }
