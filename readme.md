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
$f="$env:temp\$(Get-Random).ps1";iwr 'https://raw.githubusercontent.com/ciiqr/config/master/scripts/install.ps1' -O "$f";saps powershell -verb RunAs -ArgumentList "-NoProfile -NoExit -InputFormat None -File `"$f`" --Download -Roles base,frontend,development,gaming";exit
```

* local (change path to wherever you've clone to)
```
# open an admin powershell window to wherever you cloned to
saps powershell -verb RunAs -ArgumentList '-NoExit -command "cd ~\Dropbox\Projects\config"'; exit

# install linked to cloned path
& .\scripts\install.ps1 -Roles base,frontend,development,gaming
```

### update (via powershell)
```
saps powershell -verb RunAs -ArgumentList '-NoProfile -NoExit -InputFormat None -File \config\scripts\provision.ps1';exit
```
