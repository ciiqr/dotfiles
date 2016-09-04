# config-dotfiles
My ~/.* files


## Install
May want to specify different categories or other options
```sh
git clone https://github.com/ciiqr/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --categories "personal development frontend"
```
## Debug
To see all the commands we would run to install with the given options (files transfered/backedup, etc) specify the --debug option
```sh
./install.sh --categories "personal development frontend" --debug
```