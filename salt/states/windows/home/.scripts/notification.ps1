Param (
    [Parameter(Mandatory=$True,HelpMessage="The message text to display")]
    [string]$Message,

    [Parameter(HelpMessage="The message title")]
    [string]$Title,

    [Parameter(HelpMessage="The message type: Info,Error,Warning,None")]
    [string]$MessageType="Info",

    [Parameter(HelpMessage="The path to a file to use its icon in the system tray")]
    [string]$SysTrayIconPath='C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe',

    [Parameter(HelpMessage="The number of milliseconds to display the message.")]
    [int]$Duration=1000
)

Add-Type -AssemblyName System.Windows.Forms

$balloon = New-Object System.Windows.Forms.NotifyIcon

# Extract the icon from the file
$balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($SysTrayIconPath)

# Example TipIcons: [System.Windows.Forms.ToolTipIcon] | Get-Member -Static -Type Property
$balloon.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]$MessageType
$balloon.BalloonTipText  = $Message
$balloon.BalloonTipTitle = $Title
$balloon.Visible = $true

# Show
# TODO: this doesn't seem to work... (would be nice to support at least time=0 to wait to be manually dismissed)
$balloon.ShowBalloonTip($Duration)

# Cleanup
$balloon.Dispose()
