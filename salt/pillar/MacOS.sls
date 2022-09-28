packages:
  # base
  coreutils: coreutils # currently required for gstat, gdate, and tac
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
  calc: calc
  bat: bat # TODO: consider bat-extras

  # frontend
  google-chrome: homebrew/cask/google-chrome
  firefox: homebrew/cask/firefox
  1password: homebrew/cask/1password
  spotify: homebrew/cask/spotify
  adobe-acrobat-reader: homebrew/cask/adobe-acrobat-reader
  speedcrunch: homebrew/cask/speedcrunch
  baobab: baobab

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
  pup: pup
  wrk: wrk
  shellcheck: shellcheck
  checkbashisms: checkbashisms
  shfmt: shfmt
  docker: homebrew/cask/docker
  docker-machine: docker-machine
  meld: homebrew/cask/meld
  vscode: homebrew/cask/visual-studio-code
  sequel-pro: homebrew/cask/sequel-pro
  cliclick: cliclick

  # macos
  duti: duti

  # gpg
  gpg: gpg
