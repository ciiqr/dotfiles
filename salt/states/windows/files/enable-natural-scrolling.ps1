param(
    [switch]$test
)

function Done($code, $changed, $comment) {
    @{changed=$changed;comment=$comment} | ConvertTo-Json -Compress
    exit $code
}

$devices_to_change = Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Enum\HID\*\*\Device Parameters' FlipFlopWheel -EA 0 | Where-Object { $_.FlipFlopWheel -eq 0 }

if (($devices_to_change | Measure-Object).Count -eq 0) {
    Done 0 'no' "Natural scrolling is already enabled"
}

if ($test) {
    Done 0 'yes' "Natural scrolling would be enabled"
}

$devices_to_change | ForEach-Object { Set-ItemProperty $_.PSPath FlipFlopWheel 1 }
if ($LASTEXITCODE) {
    Done 1 'no' "Failed enabling natural scrolling"
}

Done 0 'yes' "Natural scrolling is now enabled"
