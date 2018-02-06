Param (
    [switch]$force,
    [switch]$copy,
    [string]$configDir = $( Join-Path $env:SystemDrive 'config' ),
    [string]$privateConfigDir = $( Join-Path $env:SystemDrive 'config-private' ),
    [string]$saltDir = $( Join-Path $env:SystemDrive 'salt\conf' ),
    [string[]]$roles = @()
)
$ErrorActionPreference = "Stop"

if ($PSScriptRoot -eq "") {
    $parent = [System.IO.Path]::GetTempPath()
    $name = [System.Guid]::NewGuid()
    $tmp = (New-Item -ItemType Directory -Path (Join-Path $parent $name)).FullName

    try {
        # download
        Invoke-WebRequest 'https://github.com/ciiqr/config/archive/master.zip' -OutFile "$tmp/config.zip" -UseBasicParsing
        Expand-Archive "$tmp/config.zip" -DestinationPath "$tmp"

        # install
        & "$tmp/config-master/scripts/install.ps1" -Force:$force -Copy -ConfigDir "$configDir" -PrivateConfigDir "$privateConfigDir" -SaltDir "$saltDir" -Roles "$roles"
    }
    finally {
        [System.IO.Directory]::Delete("$tmp", $true)
    }
}

. "$PSScriptRoot\include\common.ps1"

ensureRoot

# set execution polity
Set-ExecutionPolicy Bypass -Scope CurrentUser

# Get real source path
$srcRootInfo = (get-item $PSScriptRoot).parent
$srcRoot = $(if ($srcRootInfo.Target) {$srcRootInfo.Target} else {$srcRootInfo.FullName})

# Get real config path
$config = ''
try {
    $configInfo = get-item -ErrorAction Stop $configDir
    $config = $(if ($configInfo.Target) {$configInfo.Target} else {$configInfo.FullName})
}
catch [Exception] {}

# Install config
if ($srcRoot -eq $config) {
    echo "running from config directory already"
}
else {
    if ([System.IO.Directory]::Exists($configDir)) {
        confirm $force "This will delete the file located at: $configDir"
    }

    TryRemoveDirectory("$configDir")
    if (!$copy) {
        CreateSymlink "$srcRoot" "$configDir"
    }
    else {
        Copy-Item "$srcRoot" "$configDir"
    }
}

# bootstrap salt
$tmp = TempDirectory
try {
    Invoke-WebRequest 'https://raw.githubusercontent.com/saltstack/salt-bootstrap/develop/bootstrap-salt.ps1' -OutFile "$tmp/bootstrap.ps1" -UseBasicParsing
    & "$tmp/bootstrap.ps1" -version 2017.7.0 -runservice false
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

& "$PSScriptRoot/setup-salt.ps1" -ConfigDir "$configDir" -PrivateConfigDir "$privateConfigDir" -SaltDir "$saltDir" -Roles $roles

& "$PSScriptRoot/provision.ps1"
