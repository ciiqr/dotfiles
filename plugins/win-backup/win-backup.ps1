Param (
    [Parameter(Mandatory)]
    [ValidateSet("provision")]
    [string]$command,

    [Parameter(Mandatory)]
    [string]$info_json,

    [Parameter(Mandatory, ValueFromPipeline)]
    [string]$stdin
)

# stop on first error
$ErrorActionPreference = "Stop"

function backup() {
    Param (
        [Parameter(Mandatory)]
        [string]$backupDir
    )

    # make backup directory
    [void](mkdir -Force "$backupDir")

    # powershell history
    copy-item "$((Get-PSReadlineOption).HistorySavePath)" "${backupDir}\powershell-history.txt"

    # ~/Documents
    robocopy "${env:USERPROFILE}\Documents" "${backupDir}\Documents" /mir /mt /NJH

    # wow Interface\Addons
    robocopy '\Program Files (x86)\World of Warcraft\_retail_\Interface\Addons' "${backupDir}\wow\_retail_\Interface\Addons" /mir /mt /NJH

    # wow WTF
    robocopy '\Program Files (x86)\World of Warcraft\_retail_\WTF' "${backupDir}\wow\_retail_\WTF" /mir /mt /NJH
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
