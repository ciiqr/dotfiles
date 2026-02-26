Param (
    [Parameter(Mandatory)]
    [ValidateSet("provision")]
    [string]$command,

    [Parameter(Mandatory)]
    [string]$info_json,

    [Parameter(Mandatory, ValueFromPipeline)]
    [string]$stdin
)

# DEBUG
# Set-PSDebug -Trace 1

# TODO: this doesn't seem to be enough for the script to show as failed
# stop on first error
$ErrorActionPreference = "Stop"

function backup_directory() {
    Param (
        [Parameter(Mandatory)]
        [string]$source,

        [Parameter(Mandatory)]
        [string]$destination
    )

    robocopy $source $destination /MIR /MT:$env:NUMBER_OF_PROCESSORS /NJH /B /SL /SJ /R:0
}

function hide_item() {
    Param (
        [string]$path
    )

    $item = Get-Item $path -Force
    if (!($item.Attributes -band "Hidden")) {
        $item.Attributes = $item.Attributes -bor "Hidden"
    }
}

function backup() {
    Param (
        [Parameter(Mandatory)]
        [string]$backupDir
    )

    # make backup directory
    [void](mkdir -Force "$backupDir")

    # TODO: change these to be states
    # powershell history
    copy-item "$((Get-PSReadlineOption).HistorySavePath)" "${backupDir}\powershell-history.txt"

    # ~/Documents
    backup_directory -source "${env:USERPROFILE}\Documents" -destination "${backupDir}\Documents"

    # wow Interface\Addons
    backup_directory -source '\Program Files (x86)\World of Warcraft\_retail_\Interface\Addons' -destination "${backupDir}\wow\_retail_\Interface\Addons"

    # wow WTF
    backup_directory -source '\Program Files (x86)\World of Warcraft\_retail_\WTF' -destination "${backupDir}\wow\_retail_\WTF"
}

function backup_provision() {
    $baseBackupDir = "${env:USERPROFILE}\.backup"
    if (-not (Test-Path $baseBackupDir -PathType Container)) {
        @{
            status = "failed"
            changed = $false
            description = "backup"
            output = "backup: backup directory missing: $baseBackupDir"
        } | ConvertTo-Json -Compress
        return
    }

    # TODO: handle errors here better
    # hide backup directory
    hide_item "$baseBackupDir"

    $result = @{
        status = "success"
        # TODO: update based on changes above
        changed = $false
        description = "backup"
        output = ""
    }

    $result.output = (backup -backupDir "${baseBackupDir}\$($env:COMPUTERNAME.ToLower())") -join "`n"
    if (!$?) {
        $result.status = "failed"
    }

    $result | ConvertTo-Json -Compress
}

switch ($command) {
    "provision" {
        backup_provision
    }
    default {
        Write-Output "backup: unrecognized subcommand: ${command}"
        exit 1
    }
}
