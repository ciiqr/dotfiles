Param (
    [string]$configDir = $( Join-Path (Join-Path $env:UserProfile 'Projects') 'config' ),
    [string]$privateConfigDir = $( Join-Path (Join-Path $env:UserProfile 'Projects') 'config-private' ),
    [string]$saltDir = $( Join-Path $env:SystemDrive 'salt\conf' ),
    [string]$machine = '',
    [string[]]$roles = @(),
    [string]$primaryUser = ''
)
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\include\common.ps1"

ensureRoot

checkCliArgErrors

# set execution polity
Set-ExecutionPolicy Bypass -Scope CurrentUser

# bootstrap salt
$tmp = TempDirectory
try {
    Invoke-WebRequest 'https://raw.githubusercontent.com/saltstack/salt-bootstrap/develop/bootstrap-salt.ps1' -OutFile "$tmp/bootstrap.ps1" -UseBasicParsing
    & "$tmp/bootstrap.ps1" -pythonVersion 3 -runservice false

    # TODO: even this didn't work, need to figure out the issue
    # Invoke-WebRequest 'https://winbootstrap.saltproject.io' -OutFile "$tmp/bootstrap.ps1" -UseBasicParsing
    # & "$tmp/bootstrap.ps1" -version 2020.10.20 -runservice false
}
finally {
    [System.IO.Directory]::Delete("$tmp", $true)
}

# TODO: might still need these...
# # set salt perms
# WaitForFile($saltDir)
# icacls $saltDir /grant "Everyone:(OI)(CI)F"
# # wait for salt to be ready
# WaitForSalt($saltDir)

& "$PSScriptRoot/setup-salt.ps1" -ConfigDir "$configDir" -PrivateConfigDir "$privateConfigDir" -SaltDir "$saltDir" -Machine "$machine" -Roles $roles -PrimaryUser $primaryUser

& "$PSScriptRoot/provision.ps1"
