
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
  packages:
    baobab: baobab
    sublime: sublime-text-installer

server-data:
  packages:
    acl: acl
