
base:
  packages:
    libcap: libcap2-bin
    man: man
    info: info
    wget: wget
    nfs: nfs-common
    woof: woof
    htop: htop
    whois: whois
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
    lshw: lshw
    hwinfo: hwinfo
    lm-sensors: lm-sensors
    ntp: ntp
    haveged: haveged
    smartmontools: smartmontools
    apt-tools:
      - apt-file
      - aptitude
      - software-properties-common
    debconf-utils: debconf-utils
    zsh:
      - zsh
      - zsh-syntax-highlighting
    git: git

frontend:
  repositories:
    sublime:
      uri: http://ppa.launchpad.net/webupd8team/sublime-text-3/ubuntu
      keyserver: keyserver.ubuntu.com
      keyid: 75BCA694
    awesome:
      uri: http://ppa.launchpad.net/klaus-vormweg/awesome/ubuntu
      keyserver: keyserver.ubuntu.com
      keyid: 75BCA694
    noobslab-icons:
      uri: http://ppa.launchpad.net/noobslab/icons/ubuntu
      keyserver: keyserver.ubuntu.com
      keyid: 75BCA694
    google-chrome:
      uri: http://dl.google.com/linux/chrome/deb
      options: '[arch=amd64]'
      dist: stable
      key_url: https://dl-ssl.google.com/linux/linux_signing_key.pub
  packages:
    baobab: baobab
    xorg: xorg
    xterm: xterm
    rxvt: rxvt-unicode
    awesome:
      - awesome
      - awesome-extra
    compton: compton
    lxdm: lxdm
    network-manager:
      - network-manager
      - network-manager-gnome
    redshift: redshift-gtk
    lxappearance: lxappearance
    numix-blue-gtk-theme: numix-blue-gtk-theme
    oxygen-cursor-theme:
      - oxygen-cursor-theme
      - oxygen-cursor-theme-extra
    linux-dark-icons: linux-dark-icons
    sublime: sublime-text-installer
    google-chrome: google-chrome-stable
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
    dropbox:
      - nautilus-dropbox
      - python-gpgme
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

server:
  packages:
    ssh-server: openssh-server
    ddclient:
      - ddclient
      - libio-socket-ssl-perl
      - libjson-any-perl

server-data:
  packages:
    acl: acl
