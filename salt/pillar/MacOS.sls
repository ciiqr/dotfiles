base:
  zsh_etc_path: /etc
  locate_conf_path: /etc/locate.rc
  src_path: /usr/local/src

packages:
  # base
  coreutils: coreutils
  awk: gawk
  rename: rename
  less: less
  wget: wget
  # TODO: nfs
  woof: woof
  htop: htop
  whois: whois
  ssh:
    - openssh
    - ssh-copy-id
  sshfs: gromgit/fuse/sshfs-mac
  neovim: neovim
  p7zip: p7zip
  rsync: rsync
  lsof: lsof
  nmap: nmap
  screen: screen
  tmux: tmux
  units: gnu-units
  unrar: unrar # TODO: not found...
  zip: zip
  traceroute: tcptraceroute
  fdupes: fdupes
  jq: jq
  yq: python-yq
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
    - ruby-completion
    - open-completion
    - pip-completion
    - mix-completion
    - gem-completion
    - kitchen-completion
    - bashdb
  tree: tree
  # moreutils: moreutils # TODO: previously this was suggested, but even that doesn't work...: pki moreutils --without-parallel
  # TODO: net-tools: net-tools
  # TODO: inetutils: inetutils
  netcat: netcat
  socat: socat

  # frontend
  baobab: baobab
  sublime: homebrew/cask/sublime-text
  spotify: homebrew/cask/spotify
  # TODO: redshift - or use built in Night Shift (that would require some dumb things to enable from here, redshift would just require enabling the service)
  google-chrome: homebrew/cask/google-chrome
  firefox: homebrew/cask/firefox
  deluge: homebrew/cask/deluge
  1password: homebrew/cask/1password
  fbreader: homebrew/cask/fbreader
  adobe-acrobat-reader: homebrew/cask/adobe-acrobat-reader
  imagemagick: imagemagick
  speedcrunch: homebrew/cask/speedcrunch
  ntfs: gromgit/homebrew-fuse/ntfs-3g-mac
  zenity: zenity
  youtube-dl: youtube-dl
  gucharmap: gucharmap
  nethogs: nethogs
  iftop: iftop
  libnotify: libnotify

  # syncthing
  syncthing: homebrew/cask/syncthing

  # restic
  restic: restic

  # development
  git: git
  hub: hub
  gnupg: gnupg
  cloc: cloc
  pkg-config: pkg-config
  sloccount: sloccount
  pssh: pssh
  pup: pup
  wrk: wrk
  fswatch: fswatch
  shellcheck: shellcheck
  virtualbox: homebrew/cask/virtualbox
  docker:
    - docker
    - docker-compose
    - homebrew/cask/docker # AKA. Docker Desktop for Mac
  docker-machine: docker-machine
  meld: homebrew/cask/meld
  google-cloud-sdk: homebrew/cask/google-cloud-sdk
  awscli:
    - awscli
    - aws-iam-authenticator
  kubectl: kubernetes-cli
  kubectx: kubectx
  helm: helm
  minikube: minikube
  telepresence:
    - homebrew/cask/macfuse
    - datawire/blackbird/telepresence
  ansible: ansible
  # TODO: flutter:
  vscode:
    - homebrew/cask/visual-studio-code
    - java11 # required for sonarlint
      # TODO: sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
  # TODO: include salt so it gets upgraded...

  # osx
  duti: duti
  macdown: homebrew/cask/macdown

  # gpg
  gpg: gpg
