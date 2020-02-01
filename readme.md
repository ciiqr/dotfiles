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

```
sudo ~/Projects/config/scripts/install --roles "base frontend sublime development"
```

### update

```
sudo ~/Projects/config/scripts/provision
```


## windows
### compatibility
* uses several PowerShell 5 features

### install (via powershell)

```
# open an admin powershell window to wherever you cloned to
saps powershell -verb RunAs -ArgumentList '-NoExit -command "cd ~\Projects\config"'; exit

# install linked to cloned path
& .\scripts\install.ps1 -Roles base,frontend,development,gaming
```

### update (via powershell)
```
saps powershell -verb RunAs -ArgumentList '-NoProfile -NoExit -InputFormat None -File ~\Projects\config\scripts\provision.ps1';exit
```
