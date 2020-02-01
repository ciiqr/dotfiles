function CreateSymlink($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target -Force > $null
}

function TempDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    $name = [System.Guid]::NewGuid()
    $tmp = (New-Item -ItemType Directory -Path (Join-Path $parent $name)).FullName
    return $tmp
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

function checkCliArgErrors {
    if ($machine -and $roles) {
        Write-Error "cannot specify both -Machine and -Roles"
        exit 1
    }
    return
}

function ensureRoot {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Error 'must be run as an admin'
        exit 0
    }
}

function machineMatches {
    $machine = salt-call grains.get id --out newline_values_only

    findstr -I "$machine" "$saltDir\machines.yaml"
    if ($LASTEXITCODE) {
        return $false
    }
    return $true
}
