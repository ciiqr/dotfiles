
# services:
  # updatedb: updatedb.timer

  # base
  # haveged: haveged
  # smartmontools: smartd

  # server
  # ssh-server: sshd
  # ddclient: ddclient

  # server-data
  # deluge-server: deluged
  # deluge-web-server: deluged-web

packages:
  # Void
  xtools: xtools
  util-linux: util-linux

  # base
  # kernel:
  #   - linux
  #   - linux-headers
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
  # woof: woof
  htop: htop
  whois: whois
  ssh: openssh
  sshfs: fuse-sshfs
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
  # cwdiff: cwdiff
  openssl: libressl
  # watch: watch
  lshw: lshw
  # hwinfo: hwinfo
  lm-sensors: lm_sensors
  ntp: ntp
  haveged: haveged
  smartmontools: smartmontools
  zsh:
    - zsh
    - zsh-completions
    - zsh-syntax-highlighting
  #   - zshdb
  bash:
    - bash
    - bash-completion
  # terminfo:
  #   - rxvt-unicode-terminfo
  git: git

  # development
  git: git
  cloc: cloc
  pkg-config: pkg-config
  sloccount: sloccount
  # pssh: pssh
  shellcheck: shellcheck
  # swift:
  #   - swift-bin
  #   - tailor
  # swift-perfect-dependencies:
  #   - openssl
  #   - util-linux
  #   - libutil-linux
  python:
    - python
    - python3
  # bpython:
  #   - bpython
  #   - bpython2
  pip:
    - python-pip
  # python-dev:
  #   - python-dev
  #   - python3-dev
  python-setuptools: python-setuptools
  virtualenv: python-virtualenv
  nim:
    - nim
  mono:
    - mono
    # TODO: consider mono-tools
  # mono-libraries:
  #   - libgtk3.0-cil
  #   - libwebkit1.1-cil
  #   - libdbus2.0-cil
  #   - libdbus-glib2.0-cil
  cpp:
    - llvm
    - lldb
    - ninja
  valgrind: valgrind
  strace: strace
  vagrant: vagrant
  virtualbox: virtualbox-ose
  vagrant-nfs: nfs-utils
  docker:
    - docker
    - docker-compose
  meld:
    - meld
    # - gdk-pixbuf-32bit
    # - gdk-pixbuf-xlib-32bit
  qtcreator: qtcreator
  # monodevelop: monodevelop-stable
  kcachegrind: kcachegrind
  xephyr: xorg-server-xephyr
  hub: hub
  google-cloud-sdk: google-cloud-sdk
  flutter:
    - glu
    - libstdc++-32bit
    - android-studio
    # flutter-desktop-embedding dependencies
    - glfw-devel
    - libepoxy-devel
    - jsoncpp-devel
    - gtk+3-devel
    - libX11-devel
    - pkg-config
  vscode: vscode

  # frontend

  # TODO: this, and more
  xorg: xorg
  xterm: xterm
  rxvt: rxvt-unicode
  awesome:
    - awesome
    - vicious
  compton: compton
  dmenu: dmenu
  rofi: rofi
  albert: albert
  lxdm: lxdm
  network-manager:
    - NetworkManager
    - network-manager-applet
    - NetworkManager-openconnect
    - NetworkManager-openvpn
    # - networkmanager-pptp
  redshift:
    - redshift
    - redshift-gtk
  lxappearance: lxappearance
  gtk-theme-widget: numix-themes
  gtk-theme-icon: awoken-icons
  gtk-theme-cursor: breeze-obsidian-cursor-theme
  baobab: baobab
  sublime: sublime-text3
  spotify: spotify
  google-chrome:
    - chromium
    - chromium-widevine # netflix support
    - freshplayerplugin
  firefox:
    - firefox
  deluge:
    - deluge
    - deluge-gtk
  keepass:
    # - keepass
    - keepassx2
    - kpcli
  gpicview: gpicview
  fbreader: fbreader
  evince: evince
  vlc: vlc
  libreoffice:
    - libreoffice
  samba: cifs-utils
  dropbox:
    - dropbox
  fonts:
    - dejavu-fonts-ttf
    - liberation-fonts-ttf
    # - msttcorefonts (in void-packages)
    # - fonts-roboto
    - font-symbola
    - terminus-font
  pulseaudio:
    - pulseaudio
    # - pulseaudio-utils
    - pavucontrol
  xdg-open:
    - xdg-utils
  #   - perl-file-mimeinfo
  #   - gvfs-bin
  xorg-tools:
    - feh
    - xdotool
    - wmctrl
    # - suckless-tools
    - xbindkeys
    - xcalib
    # - xkbset
    # - xkeycaps
    - xsel
    # - x11-utils
  libinput:
    - libinput
    - xf86-input-libinput
  scrot: scrot
  imagemagick: GraphicsMagick
  speedcrunch: speedcrunch
  spacefm:
    - spacefm
  #   - udisks2
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
  iftop: iftop
  iotop: iotop
  # pinta: pinta
  inotify: inotify-tools
  hardinfo: hardinfo
  powertop: powertop
  libnotify: libnotify
  bleachbit: bleachbit
  seahorse: seahorse

  # gaming
  lutris:
    - lutris
    - wine-32bit
  steam: steam

  # server
  ssh-server: openssh
  ddclient:
    - ddclient
  #   - perl-json-any

  # server-data
  acl: acl
  deluge-server: deluge
  samba-server: samba
  nfs-server: nfs-utils
  minidlna: minidlna

default_programs:
  evince:
    desktop: org.gnome.Evince.desktop

frontend:
  gtk:
    theme:
      widget:
        name: Numix
      icon:
        name: AwOken
      cursor:
        name: Breeze_Obsidian
