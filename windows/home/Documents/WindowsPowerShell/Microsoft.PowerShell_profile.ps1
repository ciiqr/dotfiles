# no header
cls

# aliases
# function nk() {
#     cargo run --manifest-path $HOME\Projects\nk\Cargo.toml -q -- @args
# }

function path() {
    $env:Path.split(";")
}

# omp
if (Get-Command "oh-my-posh" -ErrorAction "SilentlyContinue") {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\probua.minimal.omp.json" | Invoke-Expression
}
