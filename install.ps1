Param (
    [Parameter(Mandatory, Position = 0)]
    [string]$machine
)

# stop on first error
$ErrorActionPreference = "Stop"

# go to repo directory
Set-Location $PSScriptRoot

# install nk
Invoke-Expression (
    (New-Object System.Net.WebClient).DownloadString(
        'https://raw.githubusercontent.com/ciiqr/nk/HEAD/install.ps1'
    )
)

# add to path
$env:Path = "${HOME}/.nk/bin" + [IO.Path]::PathSeparator + $env:Path

# configure machine
Write-Output '==> configure machine'
nk var set machine $machine

# provision
Write-Output '==> provision'
nk provision
