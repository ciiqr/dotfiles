# no header
Clear-Host

# stop on first error
$ErrorActionPreference = "Stop"

# aliases
function path() {
    $env:Path.split(";")
}

function nk() {
    Set-Location C:\Users\william\Projects\dotfiles
    nk.exe @args
}

# omp
if (Get-Command "oh-my-posh" -ErrorAction "SilentlyContinue") {
    oh-my-posh disable notice
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\probua.minimal.omp.json" | Invoke-Expression
}
