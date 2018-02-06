function CreateSymlink($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target -Force > $null
}

function CustomTempDirectory {
    # NOTE: I would rather generate a unique directory name and then delete it when done,
    # but windows is stupid with the permissions of the newly downloaded file

    $parent = [System.IO.Path]::GetTempPath()
    $tmp = Join-Path $parent 'workstation'
    if (![System.IO.Directory]::Exists($tmp)) {
        [System.IO.Directory]::CreateDirectory($tmp) > $null
    }
    return $tmp
}

function TryRemoveDirectory($dir) {
    if ([System.IO.Directory]::Exists($dir)) {
        [System.IO.Directory]::Delete($dir, $true)
    }
}

function WaitForFile($file) {
    while (!(Test-Path $file)) {
        echo "Waiting for $file to appear"
        Start-Sleep 5
    }
    Start-Sleep 5
}

function WaitForSalt($salt) {
    # source: https://gist.github.com/deuscapturus/8f18d28d1a1ccef6327c
    $saltCallExe = Join-Path $salt 'salt-call.exe'
    $saltCallBat = Join-Path $salt 'salt-call.bat'
    # TODO: this OR something to check last change of salt dir instead of all this and wait at least 10 seconds for new changes or maybe we can even check for the program doing these things...
    # '/salt/bin/Scripts/salt-call':
    while (!(Test-Path $saltCallExe) -and !(Test-Path $saltCallBat)) {
        echo 'Waiting for salt-call to appear'
        Start-Sleep 5
    }
    Start-Sleep -s 15
}

function ensureRoot {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        echo 'must be run as an admin'
        exit 0
    }
}
