# config

* [linux/osx](#linuxosx)
    * [install](#install)
    * [update](#update)
* [windows](#windows)
    * [compatibility](#compatibility)
    * [install (via powershell)](#install-via-powershell)
    * [update (via powershell)](#update-via-powershell)

## linux/osx

### install

* remote

```
curl -sL https://raw.githubusercontent.com/ciiqr/config/master/scripts/install | sudo bash -s -- --roles "base frontend sublime development"
```

* local (change path to wherever you've cloned to)

```
sudo ~/projects/config/scripts/install --roles "base frontend sublime development"
```

### update

```
sudo /config/scripts/provision
```


## windows
### compatibility
* uses several PowerShell 5 features

### install (via powershell)

* remote
```
# TODO: need to update this for supplying -Roles param...
Start-Process powershell -ArgumentList '-NoProfile -NoExit -InputFormat None -Command "iex ((New-Object System.Net.WebClient).DownloadString(\"https://raw.githubusercontent.com/ciiqr/config/master/scripts/install.ps1\"))"' -verb RunAs; exit
```

* local (change path to wherever you've clone to)
```
# open an admin powershell window to wherever you cloned to
Start-Process powershell -ArgumentList '-NoExit -command "cd C:\Users\william\Dropbox\Projects\config"' -verb RunAs; exit

# install linked to cloned path
& .\scripts\install.ps1 -Roles base,frontend,development,gaming
```

### update (via powershell)
```
Start-Process powershell -ArgumentList '-NoProfile -NoExit -InputFormat None -File C:\config\scripts\provision.ps1' -verb RunAs; exit
```
