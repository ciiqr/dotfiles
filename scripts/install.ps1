Param (
    [switch]$force,
    [switch]$copy,
    [string]$configDir = $( Join-Path $env:SystemDrive 'config' ),
    [string]$privateConfigDir = $( Join-Path $env:SystemDrive 'config-private' ),
    [string]$saltDir = $( Join-Path $env:SystemDrive 'salt\conf' ),
    [string[]]$roles = @()
)

$ErrorActionPreference = "Stop"

# . "$PSScriptRoot\include\common.ps1"

echo "PSScriptRoot: $PSScriptRoot"
