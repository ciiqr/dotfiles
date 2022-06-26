services:
  # base
  smartmontools: smartd

packages:
  # base
  kernel: linux-generic
  coreutils: coreutils
  awk: gawk
  libcap: libcap2-bin
  man: man-db
  info: info
  wget: wget
  nfs: nfs-common
  # woof: woof
  htop: htop
  whois: whois
  ssh: openssh-client
  sshfs: sshfs
  neovim: neovim
  p7zip: p7zip
  rsync: rsync
  mlocate: mlocate
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
  # TODO: (python version) yq: yq
  colordiff: colordiff
  openssl: openssl
  # watch: watch
  lshw: lshw
  hwinfo: hwinfo
  lm-sensors: lm-sensors
  ntp: ntp
  smartmontools: smartmontools
  zsh:
    - zsh
    - zsh-syntax-highlighting
  bash:
    - bash
    - bash-completion
  # TODO: net-tools: net-tools
  # TODO: inetutils: inetutils
  git: git
