Param (
    [string]$configDir = $( Join-Path (Join-Path $env:UserProfile 'Projects') 'config' ),
    [string]$privateConfigDir = $( Join-Path (Join-Path $env:UserProfile 'Projects') 'config-private' ),
    [string]$saltDir = $( Join-Path $env:SystemDrive 'salt\conf' ),
    [string]$machine = '' ,
    [string]$primaryUser = ''
)

$ErrorActionPreference = "Stop"

. "$PSScriptRoot\include\common.ps1"

ensureRoot

checkCliArgErrors

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
if ($privateConfigDir) {
    CreateSymlink "$privateConfigDir\salt\etc\machines.yaml" "$saltDir\machines.yaml"
}

# grains

# sync all
salt-call saltutil.sync_all --out quiet

# determine platform
$platform = salt-call platform.get_name --out newline_values_only
if ([string]::IsNullOrWhiteSpace($platform)) {
    Write-Error "unknown platform"
    exit 1
}

# determine primary user
if (!$primaryUser) {
    $primaryUser = salt-call grains.get primaryUser --out newline_values_only
    if (!$primaryUser) {
        $primaryUser="$env:UserName"
    }
}

# set config/private-config dirs
salt-call grains.set configDir "$configDir" --out quiet
salt-call grains.set privateConfigDir "$privateConfigDir" --out quiet

# set user
salt-call grains.set primaryUser "$primaryUser" --out quiet

# set platform
salt-call grains.set platform "$platform" --out quiet

# setup machine
if ($machine) {
    try
    {
        $stream = [System.IO.StreamWriter]::new("$saltDir\minion_id")
        $stream.Write($machine)
    }
    finally
    {
        $stream.close()
    }
}


# apply bootstrap state (for installing package managers and such)
salt-call state.apply bootstrap

# TODO: will this work on first install?
# TODO: setup a test virtualbox env to see
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
