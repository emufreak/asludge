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

# Function to calculate the width of a string
function Get-StringWidth {
    param (
        [string]$inputString
    )
    
    $totalWidth = 0
    
    foreach ($char in $inputString.ToCharArray()) {
        switch ($char) {
            '%' { $char = 'percent'}
            '$' { $char = 'dollar'}
            '*' { $char = 'asterisk'}
            '#' { $char = 'hash'}
            '.' { $char = 'period'}
            ',' { $char = 'comma'}
            ':' { $char = 'colon'}
            ';' { $char = 'semicolon'}
            '-' { $char = 'hyphen'}
            "'" { $char = 'apostrophe'}
            '"' { $char = 'quotation'}
            '<' { $char = 'less_than'}
            '>' { $char = 'greater_than'}
            '/' { $char = 'slash'}
            '?' { $char = 'question'}
            '!' { $char = 'exclamation'}
            '(' { $char = 'left_parenthesis'}
            ')' { $char = 'right_parenthesis'}
            '+' { $char = 'plus'}
            '=' { $char = 'equal'}
            '_' { $char = 'underscore'}
            ' ' { $char = 'space'}
        }
        if ($charWidths.ContainsKey($char.ToString())) {
            $totalWidth += $charWidths[$char.ToString()]
        } else {
            Write-Host "Warning: No width defined for character '$char'"
        }
    }
    
    return $totalWidth
}

# Get user input
$inputString = Read-Host "Enter a string to calculate width"

# Calculate and display the width
$totalWidth = Get-StringWidth -inputString $inputString
Write-Host "Total width of the string: $totalWidth"
