# TODO: manage all AUR packages myself: yay -Qme

services:
  man-db: man-db.timer
  updatedb: updatedb.timer

  # base
  smartmontools: smartd

packages:
  # Arch
  pacman-tools:
    - pkgfile
    - pkgtools
    # - pacdiffviewer # TODO: aur
  util-linux:
    - util-linux
    - util-linux-libs

  # base
  kernel:
    # TODO: maybe this shouldn't even be here
    - linux
    - linux-headers
  # TODO: do I want to purge normal kernel?
  # kernel:
  #   - linux-lts
  #   - linux-lts-headers
  coreutils: coreutils
  awk: gawk
  bc: bc
  libcap: libcap
  man:
    - man-db
    - man-pages
  info: texinfo
  wget: wget
  nfs: nfs-utils
  woof: woof
  htop: htop
  whois: whois
  ssh: openssh
  sshfs: sshfs
  neovim: neovim
  p7zip: p7zip
  rsync: rsync
  mlocate: mlocate
  cronie: cronie
  incron: incron
  lsof: lsof
  nmap: nmap
  screen: screen
  tmux: tmux
  units: units
  unrar: unrar
  zip:
    - zip
    - unzip
  traceroute: traceroute
  fdupes: fdupes
  jq: jq
  yq: yq
  colordiff: colordiff
  cwdiff: cwdiff
  openssl: openssl
  # watch: watch
  parallel: parallel
  bind: bind
  lshw: lshw
  hwinfo: hwinfo
  lm-sensors: lm_sensors
  ntp: ntp
  smartmontools: smartmontools
  zsh:
    - zsh
    - zsh-completions
    - zsh-syntax-highlighting
    - zshdb
  bash:
    - bash
    - bash-completion
  tree: tree
  moreutils: moreutils
  net-tools: net-tools
  inetutils: inetutils
  netcat: gnu-netcat
  socat: socat
  fzf: fzf

  # development
  git: git
  gnupg: gnupg
  cloc: cloc
  pkg-config: pkgconf
  sloccount: sloccount
  # pssh: pssh
  pup: pup
  # wrk: wrk
  # fswatch: fswatch
  shellcheck: shellcheck
  checkbashisms: checkbashisms
  shfmt: shfmt
  virtualbox:
    - virtualbox
    - virtualbox-host-modules-arch
  docker:
    - docker
    - docker-compose
  podman:
    - podman
    - podman-compose
  docker-machine: docker-machine
  meld: meld
  qtcreator: qtcreator
  kcachegrind: kcachegrind
  xephyr: xorg-server-xephyr
  hub: hub
  # google-cloud-sdk: google-cloud-sdk
  kubectl: kubectl
  kubectx: kubectx
  helm: helm
  minikube: minikube
  # telepresence: telepresence # TODO aur
  ansible: ansible
  # flutter:
  #   - glu
  #   - libstdc++-32bit
  #   - android-studio
  #   # flutter-desktop-embedding dependencies
  #   - glfw-devel
  #   - libepoxy-devel
  #   - jsoncpp-devel
  #   - gtk+3-devel
  #   - libX11-devel
  #   - pkg-config
  vscode: visual-studio-code-bin # TODO: aur...
  installer-arch:
    - archiso
    - edk2-ovmf
    - qemu

  # gnutls:
  #   - gnutls-tools
  kotlin: kotlin
  android-studio: android-studio
  # TODO: rename? android-udev is specifically for adb to connect to devices & other sdk tools are installed in the linux.sls
  android-sdk:
    - android-udev
  rust:
    - rust-src
    - rustup


  # frontend

  # TODO: this, and more
  # xorg: xorg
  xterm: xterm
  awesome:
    - awesome
    - vicious
  picom: picom
  dmenu: dmenu
  rofi: rofi
  # albert: albert
  slim:
    - slim
    - archlinux-themes-slim
  network-manager:
    - networkmanager
    - nm-connection-editor
    - network-manager-applet
    - networkmanager-openconnect
    - networkmanager-openvpn
    - networkmanager-pptp
  redshift:
    - redshift
    - gtk3
    - python-gobject
    - python-pyxdg
  lxappearance: lxappearance-gtk3
  gtk-theme-widget: qogir-gtk-theme-git
  gtk-theme-icon: qogir-icon-theme-git
  gtk-theme-cursor: xcursor-breeze
  sublime: sublime-text-4
  spotify: spotify
  google-chrome: google-chrome
  firefox:
    - firefox
    - firefox-developer-edition
  deluge:
    - deluge-gtk
    - libappindicator-gtk3
    - libnotify
  1password: 1password
  gpicview: gpicview
  fbreader: fbreader
  evince: evince
  vlc: vlc
  libreoffice:
    - libreoffice-fresh
    - gtk3
  samba: cifs-utils
  # fonts:
  #   - fonts-dejavu
  #   - fonts-liberation
  #   - ttf-mscorefonts-installer
  #   - fonts-roboto
  #   - fonts-symbola
  #   - xfonts-terminus
  pulseaudio:
    - pulseaudio
  #   - pulseaudio-utils
    - pavucontrol
  blueman: blueman
  xdg-open:
    - xdg-utils
    - perl-file-mimeinfo
  #   - gvfs-bin
  xorg-tools:
    - feh
    - xdotool
    - wmctrl
  #   - suckless-tools
    - xbindkeys
  #   - xkbset
    - xkeycaps
    - xsel
  #   - x11-utils
    - xorg-xdpyinfo
    - xorg-xrdb
    - xorg-xev
  libinput:
    - libinput
    - xf86-input-libinput
  scrot: scrot
  imagemagick: imagemagick
  speedcrunch: speedcrunch
  spacefm:
    - spacefm
    - udisks2
  gparted: gparted
  # gksu: gksu
  gcolor: gcolor3
  baobab: baobab
  ntfs: ntfs-3g
  zenity: zenity
  youtube-dl: youtube-dl
  gucharmap: gucharmap
  leafpad: leafpad
  nethogs: nethogs
  iftop: iftop
  iotop: iotop
  pinta: pinta
  inotify: inotify-tools
  hardinfo: hardinfo
  powertop: powertop
  libnotify: libnotify
  bleachbit: bleachbit
  arandr: arandr
  seahorse: seahorse
  discord: discord
  pa-server:
    - python-gobject
    - dbus-python
    - python-setproctitle
  x11-query-screens-resolution:
    - python-xlib

  # syncthing
  syncthing:
    - syncthing
    - syncthingtray

  # restic
  restic: restic

  # gaming
  lutris:
    - lutris
    - wine
    # - wine-gaming-nine # TODO: aur?
    - wine-staging
  # steam: steam
