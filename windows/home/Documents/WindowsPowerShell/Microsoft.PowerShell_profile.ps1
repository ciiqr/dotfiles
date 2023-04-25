# no header
cls

# stop on first error
$ErrorActionPreference = "Stop"

# aliases
# function nk() {
#     cargo run --manifest-path $HOME\Projects\nk\Cargo.toml -q -- @args
# }

function path() {
    $env:Path.split(";")
}

function backup() {
    $backupDir = "${env:USERPROFILE}\.backup\$($env:COMPUTERNAME.ToLower())"

    # make backup directory
    [void](mkdir -Force "$backupDir")

    # backup files
    echo "==> backup files"

    echo "- powershell history"
    copy-item "$((Get-PSReadlineOption).HistorySavePath)" "${backupDir}\powershell-history.txt"

    echo "- ~/Documents"
    robocopy "${env:USERPROFILE}\Documents" "${backupDir}\Documents" /mir /mt /NJH

    echo "- wow Interface\Addons"
    robocopy '\Program Files (x86)\World of Warcraft\_retail_\Interface\Addons' "${backupDir}\wow\_retail_\Interface\Addons" /mir /mt /NJH

    echo "- wow WTF"
    robocopy '\Program Files (x86)\World of Warcraft\_retail_\WTF' "${backupDir}\wow\_retail_\WTF" /mir /mt /NJH
}

# omp
if (Get-Command "oh-my-posh" -ErrorAction "SilentlyContinue") {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\probua.minimal.omp.json" | Invoke-Expression
}
