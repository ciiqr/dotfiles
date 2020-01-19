
base:
  zsh_etc_path: /etc
  locate_conf_path: /etc/locate.rc
  src_path: /usr/local/src

packages:
  # base
  coreutils: coreutils
  awk: gawk
  less: less
  wget: wget
  # TODO: nfs
  woof: woof
  htop: htop
  whois: whois
  ssh:
    - openssh
    - ssh-copy-id
  sshfs:
    - caskroom/cask/osxfuse
    - sshfs
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
  colordiff: colordiff
  openssl: openssl@1.1
  watch: watch
  parallel: parallel
  # TODO: ntp
  smartmontools: smartmontools
  zsh:
    - zsh
    - zsh-completions
    - zsh-syntax-highlighting
    - zsh-autosuggestions
    - zshdb
  bash:
    - bash
    - bash-completion@2
    - brew-cask-completion
    - launchctl-completion
    - packer-completion
    - vagrant-completion
    - ruby-completion
    - open-completion
    - pip-completion
    - mix-completion
    - gem-completion
    - kitchen-completion
    - bashdb
  tree: tree
  git: git

  # frontend
  baobab: baobab
  sublime: caskroom/cask/sublime-text
  spotify: caskroom/cask/spotify
  yakyak: caskroom/cask/yakyak
  # TODO: redshift - or use built in Night Shift (that would require some dumb things to enable from here, redshift would just require enabling the service)
  google-chrome: caskroom/cask/google-chrome
  firefox: caskroom/cask/firefox
  deluge: caskroom/cask/deluge
  keepass:
    - caskroom/cask/keepassx
    - kpcli
  1password: caskroom/cask/1password
  fbreader: caskroom/cask/fbreader
  imagemagick: imagemagick
  speedcrunch: caskroom/cask/speedcrunch
  ntfs: ntfs-3g
  zenity: zenity
  youtube-dl: youtube-dl
  gucharmap: gucharmap
  nethogs: nethogs
  iftop: iftop
  libnotify: libnotify

  # syncthing
  syncthing: caskroom/cask/syncthing

  # development
  git: git
  hub: hub
  gnupg2: gnupg
  cloc: cloc
  pkg-config: pkg-config
  sloccount: sloccount
  pssh: pssh
  pup: pup
  wrk: wrk
  fswatch: fswatch
  shellcheck: shellcheck
  python:
    - python
    - python@2
  # TODO: bpython
  nim: nim
  mono: mono
  cpp:
    - clang-format
    - llvm
    - ninja
  go: go@1.12
  vagrant: caskroom/cask/vagrant
  virtualbox: caskroom/cask/virtualbox
  docker:
    - docker
    - docker-compose
    - caskroom/cask/docker # AKA. Docker Desktop for Mac
  docker-machine: docker-machine
  meld: caskroom/cask/meld
  google-cloud-sdk: caskroom/cask/google-cloud-sdk
  awscli: awscli
  kubectl: kubectl
  kubectx: kubectx
  helm: kubernetes-helm
  k9s: derailed/k9s/k9s
  minikube: caskroom/cask/minikube
  ansible: ansible
  # TODO: flutter:
  vscode: caskroom/cask/visual-studio-code

development:
  git:
    config:
      gpg.program: gpg
