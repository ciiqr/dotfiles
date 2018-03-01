Param (
    [string]$configDir = $( Join-Path $env:SystemDrive 'config' ),
    [string]$privateConfigDir = $( Join-Path $env:SystemDrive 'config-private' ),
    [string]$saltDir = $( Join-Path $env:SystemDrive 'salt\conf' ),
    [string[]]$roles = @(),
    [string]$primaryUser = ''
)

$ErrorActionPreference = "Stop"

. "$PSScriptRoot\include\common.ps1"

ensureRoot

# create salt directory
mkdir -Force "$saltDir"


# setup configs

# files
$files_content = @"
ext_pillar:
  - stack: $configDir\salt\pillar\stack.sls

file_roots:
  base:
    $(If ($privateConfigDir) {"- $privateConfigDir\salt\states"} Else {""})
    - $configDir\salt\states

pillar_roots:
  base:
    $(If ($privateConfigDir) {"- $privateConfigDir\salt\pillar"} Else {""})
    - $configDir\salt\pillar
"@

try
{
    $stream = [System.IO.StreamWriter]::new("$saltDir\files.conf")
    $stream.Write($files_content)
}
finally
{
    $stream.close()
}


# minion
CreateSymlink "$configDir\salt\etc\minion.yaml" "$saltDir\minion"

# grains

# sync modules
salt-call saltutil.refresh_modules --out quiet

# determine platform
$platform = salt-call platform.get_name --out newline_values_only
if ([string]::IsNullOrWhiteSpace($platform)) {
    Write-Error "unknown platform"
    exit 1
}

# determine primary user
if (!$primaryUser) {
    $primaryUser = salt-call grains.get roles --out newline_values_only
    if (!$primaryUser) {
        $primaryUser="$env:UserName"
    }
}

# if roles are not specified, try getting the existing roles
if ($roles.Count -eq 0) {
    $roles = salt-call grains.get roles --out newline_values_only
}

# set config/private-config dirs
salt-call grains.set configDir "$configDir" --out quiet
salt-call grains.set privateConfigDir "$privateConfigDir" --out quiet

# set user
salt-call grains.set primaryUser "$primaryUser" --out quiet

# set platform
salt-call grains.set platform "$platform" --out quiet

# set roles
salt-call grains.delkey roles --out quiet
$roles | foreach {
    salt-call grains.append roles "$_" --out quiet
}


# apply bootstrap state (for installing package managers and such)
salt-call state.apply bootstrap
