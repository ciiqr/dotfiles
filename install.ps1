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

# provision
Write-Output '==> provision'
nk provision
