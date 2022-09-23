base:
  zsh_etc_path: /etc
  locate_conf_path: /etc/locate.rc

packages:
  # base
  coreutils: coreutils # currently required for gstat
  # NOTE: only if required:
  # - moreutils
  # - net-tools
  # - inetutils
  awk: gawk
  rename: rename
  less: less
  wget: wget
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
  lzip: lzip
  fdupes: fdupes
  jq: jq
  yq: python-yq
  colordiff: colordiff
  openssl: openssl@1.1
  watch: watch
  parallel: parallel
  zsh:
    # - zsh # should probably just use system version
    - zsh-completions
    - zsh-syntax-highlighting
    - zsh-autosuggestions
    - zshdb
  bash:
    - bash
    - bash-completion@2
    - brew-cask-completion
    - launchctl-completion
    - vagrant-completion
    - open-completion
    - bashdb
  tree: tree
  netcat: netcat
  socat: socat
  fzf: fzf
  fd: fd

  # frontend
  baobab: baobab
  sublime: homebrew/cask/sublime-text
  spotify: homebrew/cask/spotify
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
  inconsolata: homebrew/cask-fonts/font-inconsolata

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
  pup: pup
  wrk: wrk
  fswatch: fswatch
  shellcheck: shellcheck
  checkbashisms: checkbashisms
  shfmt: shfmt
  docker: homebrew/cask/docker
  docker-machine: docker-machine
  meld: homebrew/cask/meld
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
  vscode: homebrew/cask/visual-studio-code
  sequel-pro: homebrew/cask/sequel-pro
  cliclick: cliclick

  # osx
  duti: duti

  # gpg
  gpg: gpg
