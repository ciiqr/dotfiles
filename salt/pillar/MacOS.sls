
base:
  zsh_etc_path: /etc
  packages:
    wget: wget
    # TODO: nfs
    woof: woof
    htop: htop
    whois: whois
    sshfs: sshfs
    nano: nano
    p7zip: p7zip
    rsync: rsync
    lsof: lsof
    nmap: nmap
    screen: screen
    units: gnu-units
    unrar: unrar
    zip: zip
    traceroute: tcptraceroute
    fdupes: fdupes
    jq: jq
    # TODO: ntp
    smartmontools: smartmontools
    zsh:
      - zsh
      - zsh-completions
      - zsh-syntax-highlighting
      - zsh-autosuggestions
      - zshdb
    git: git

frontend:
  packages:
    baobab: baobab
    sublime: caskroom/cask/sublime-text
    spotify: caskroom/cask/spotify
    # TODO: redshift - or use built in Night Shift (that would require some dumb things to enable from here, redshift would just require enabling the service)
    google-chrome: caskroom/cask/google-chrome
    firefox: caskroom/versions/firefox-developer-edition
    deluge: caskroom/cask/deluge
    keepass:
      - caskroom/cask/keepassx
      - kpcli
    # TODO: gpicview
    # TODO: fbreader
    # TODO: evince
    # TODO: vlc
    # TODO: libreoffice
    # TODO: samba
    # TODO: dropbox
    # TODO: fonts
    # TODO: imagemagick
    # TODO: speedcrunch
    # TODO: ntfs
    # TODO: zenity
    # TODO: youtube-dl
    # TODO: gucharmap
    # TODO: leafpad
    # TODO: nethogs
    # TODO: rfkill
    # TODO: iftop
    # TODO: iotop
    # TODO: pinta
    # TODO: inotify
    # TODO: hardinfo
    # TODO: powertop
    # TODO: libnotify


# TODO: continue going through this list of packages, and adding anything that's appliable

# development: build-essential
# development: git
# development: cloc
# development: pkg-config
# development: sloccount
# development: shellcheck
# development: swift-perfect-dependencies
# development: python
# development: bpython
# development: pip
# development: python-dev
# development: python-setuptools
# development: virtualenv
# development: nim
# development: mono
# development: mono-libraries
# development: cpp
# development: valgrind
# development: strace
# development: installer-ubuntu
# development: virtualbox
# development: vagrant-nfs
# development: meld
# development: virtualbox-ui
# development: qtcreator
# development: monodevelop
# development: kcachegrind
