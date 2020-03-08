
services:
  # base
  haveged: haveged
  smartmontools: smartd

  # server-data
  deluge-server: deluged
  deluge-web-server: deluged-web

repositories:
  # frontend
  sublime:
    uri: http://ppa.launchpad.net/webupd8team/sublime-text-3/ubuntu
    keyserver: keyserver.ubuntu.com
    keyid: 75BCA694
  spotify:
    uri: http://repository.spotify.com
    dist: stable
    comps: non-free
    keyserver: hkp://keyserver.ubuntu.com:80
    keyid: 0DF731E45CE24F27EEEB1450EFDC8610341D9410
  awesome:
    uri: http://ppa.launchpad.net/klaus-vormweg/awesome/ubuntu
    keyserver: keyserver.ubuntu.com
    keyid: 75BCA694
  noobslab-icons:
    uri: http://ppa.launchpad.net/noobslab/icons/ubuntu
    keyserver: keyserver.ubuntu.com
    keyid: 75BCA694
  lutris:
    uri: https://download.opensuse.org/repositories/home:/strycore/xUbuntu_18.04
    # TODO: can we do this less dumbly?
    dist: ./
    comps: ""
    key_url: https://download.opensuse.org/repositories/home:/strycore/xUbuntu_18.04/Release.key

packages:
  # Ubuntu
  ubuntu-drivers-common: ubuntu-drivers-common

  # base
  kernel: linux-generic
  coreutils: coreutils
  awk: awk
  libcap: libcap2-bin
  man: man
  info: info
  wget: wget
  nfs: nfs-common
  woof: woof
  htop: htop
  whois: whois
  ssh: openssh-client
  sshfs: sshfs
  nano: nano
  p7zip: p7zip
  rsync: rsync
  mlocate: mlocate
  incron: incron
  lsof: lsof
  nmap: nmap
  screen: screen
  units: units
  unrar: unrar
  zip:
    - zip
    - unzip
  traceroute: traceroute
  fdupes: fdupes
  jq: jq
  colordiff: colordiff
  openssl: openssl
  # watch: watch
  lshw: lshw
  hwinfo: hwinfo
  lm-sensors: lm-sensors
  ntp: ntp
  haveged: haveged
  smartmontools: smartmontools
  zsh:
    - zsh
    - zsh-syntax-highlighting
  bash:
    - bash
    - bash-completion

  # development
  build-essential: build-essential
  git: git
  cloc: cloc
  pkg-config: pkg-config
  sloccount: sloccount
  pssh: pssh
  shellcheck: shellcheck
  swift-perfect-dependencies:
    - openssl
    - libssl-dev
    - uuid-dev
  python:
    - python
    - python3.6
  bpython:
    - bpython
    - bpython3
  pip:
    - python-pip
    - python3-pip
  python-dev:
    - python-dev
    - python3-dev
  python-setuptools:
    - python-setuptools
    - python3-setuptools
  virtualenv:
    - python-virtualenv
    - python3-virtualenv
    - virtualenv
  nim: nim
  mono:
    - mono-complete
    - nuget
  mono-libraries:
    - libgtk3.0-cil
    - libwebkit1.1-cil
    - libdbus2.0-cil
    - libdbus-glib2.0-cil
  cpp:
    - clang
    - clang-format
    - libclang-dev
    - llvm
    - lldb
    - ninja-build
  valgrind: valgrind
  strace: strace
  installer-ubuntu:
    - debconf-utils
    - genisoimage
    - xorriso
    # TODO: Maybe also syslinux syslinux-common
  virtualbox: virtualbox
  virtualbox-ui: virtualbox-qt
  vagrant-nfs:
    - nfs-common
    - nfs-kernel-server
  docker:
    - docker.io
    - docker-compose
  meld: meld
  qtcreator: qtcreator
  monodevelop: monodevelop
  kcachegrind: kcachegrind
  xephyr: xserver-xephyr
  # TODO: flutter-desktop-embedding dependencies: libglfw3-dev libepoxy-dev libjsoncpp-dev libgtk-3-dev libx11-dev pkg-config

  # frontend
  xorg: xorg
  xterm: xterm
  rxvt: rxvt-unicode
  awesome:
    - awesome
    - awesome-extra
  compton: compton
  dmenu: suckless-tools
  rofi: rofi
  lxdm: lxdm
  network-manager:
    - network-manager
    - network-manager-gnome
  redshift: redshift-gtk
  lxappearance: lxappearance
  gtk-theme-widget: numix-blue-gtk-theme
  gtk-theme-icon: linux-dark-icons
  gtk-theme-cursor:
    - oxygen-cursor-theme
    - oxygen-cursor-theme-extra
  sublime: sublime-text-installer
  spotify: spotify-client
  google-chrome:
    - chromium-browser
    - adobe-flashplugin # TODO: confirm required...
    - browser-plugin-freshplayer-pepperflash
  firefox: firefox
  deluge: deluge
  keepass:
    - keepass2
    - keepassx
    - kpcli
  gpicview: gpicview
  fbreader: fbreader
  evince: evince
  vlc: vlc
  libreoffice:
    - libreoffice-writer
    - libreoffice-calc
  samba: cifs-utils
  fonts:
    - fonts-dejavu
    - fonts-liberation
    # TODO: broken? - ttf-mscorefonts-installer
    - fonts-roboto
    - fonts-symbola
    - xfonts-terminus
  pulseaudio:
    - pulseaudio
    - pulseaudio-utils
    - pavucontrol
  xdg-open:
    - xdg-utils
    - libfile-mimeinfo-perl
    - gvfs-bin
  xorg-tools:
    - feh
    - xdotool
    - wmctrl
    - suckless-tools
    - xbindkeys
    - xcalib
    - xkbset
    - xkeycaps
    - xsel
    - x11-utils
  libinput:
    - libinput-tools
    - libinput10
    - xserver-xorg-input-libinput
  scrot: scrot
  imagemagick:
    - graphicsmagick
    - graphicsmagick-imagemagick-compat
  speedcrunch: speedcrunch
  spacefm:
    - spacefm-gtk3
    - udisks2
  gparted: gparted
  gksu: gksu
  gcolor2: gcolor2
  baobab: baobab
  ntfs: ntfs-3g
  zenity: zenity
  youtube-dl: youtube-dl
  gucharmap: gucharmap
  leafpad: leafpad
  nethogs: nethogs
  rfkill: rfkill
  iftop: iftop
  iotop: iotop
  pinta: pinta
  inotify: inotify-tools
  hardinfo: hardinfo
  powertop: powertop
  libnotify: libnotify-bin
  bleachbit: bleachbit
  seahorse: seahorse

  # gaming
  lutris: lutris

  # TODO: wow: https://github.com/lutris/lutris/wiki/Game:-Blizzard-App
    # https://github.com/lutris/lutris/wiki/Game:-World-of-Warcraft
    # https://gist.github.com/itsjaredbs/8c4ef0764dcec868b3a9ca595a81947b
    # https://gist.github.com/itsjaredbs/b436606f6758a7b2125b947269817fc3
  # TODO: install wine staging
    # sudo apt remove wine
    # # Install Wine Staging the way you normally would with Apt.
    # sudo apt install wine-staging
    # # That will give you the basic install. There are plenty of recommended packages that you can install for additional functionality. You can install them along with staging for the most complete experience.
    # sudo apt install --install-recommends winehq-staging
  # key: https://repos.wine-staging.com/wine/Release.key
  # repo: https://dl.winehq.org/wine-builds/ubuntu/

  # server
  ssh-server: openssh-server

frontend:
  gtk:
    theme:
      widget:
        name: NumixBlue
      icon:
        name: Linux-Dark
      cursor:
        name: oxy-obsidian-hc
