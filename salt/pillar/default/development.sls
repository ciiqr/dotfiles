development:
  git:
    config:
      user.name: William Villeneuve
      push.default: simple
      pull.rebase: 'true'
      color.ui: 'true'
      rerere.enabled: 'true'
      diff.renames: 'copies' # Detect copies as well as renames
      # TODO: Reconsider core.pager 'less'

      # gpg
      gpg.program: gpg2
      commit.gpgsign: 'true'

      alias.cm: '!git commit -m'
      # TODO: make these work with the yaml
      # alias.cmb: |
      #   !f() { \
      #     git cm "$(git symbolic-ref --short -q HEAD): $1" "${@:2}"; \
      #   }; f
      # alias.new: |
      #   '!f() { \
      #     git checkout -b "$1";git push -u origin "$1"; \
      #   }; f'
      # TODO: for now just:
      # git config --global alias.new '!f() { git checkout -b "$1";git push -u origin "$1"; }; f'
      # git config --global alias.cmb '!f() { \
      #   git cm "$(git rev-parse --abbrev-ref HEAD): $1" "${@:2}"; \
      # }; f'
      alias.st: status
      alias.co: checkout
      alias.br: branch
      alias.dcw: '!git diff --cached -w'
      alias.dc: '!git diff --cached'
      alias.lp: '!git log --color --pretty=format:"%C(yellow)%h%C(reset) %s%C(bold red)%d%C(reset) %C(green)%ad%C(reset) %C(blue)[%an]%C(reset)" --relative-date --decorate'
      alias.contributors: '!git shortlog -s -n -e'
      # TODO: git config --global alias.alias 'config --get-regexp ^alias\\.'
      alias.alias: 'config --get-regexp ^alias\\.'
      # TODO: fix
      # git add -A; git cm "debug"; git push;
      # git config --global alias.debug '!f() { git add -A; git cm "debug"; git push; }; f'

  hashicorp:
    platform_map:
      osx: darwin
      linux: linux
    arch_map:
      x86_64: amd64
  vagrant:
    version: 2.0.3
  terraform:
    version: 0.11.14
    hash_map:
      osx: sha256=829bdba148afbd61eab4aafbc6087838f0333d8876624fe2ebc023920cfc2ad5
      linux: sha256=9b9a4492738c69077b079e595f5b2a9ef1bc4e8fb5596610f69a6f322a8af8dd
    # version: 0.12.0-beta2
    # hash_map:
    #   linux: sha256=ad7515000955fe4a32757dc92e36f7b4d046bc51f3d683cf1e691bb7a6dc09a4
  packer:
    version: 1.1.1
    hash_map:
      osx: sha256=8f8a043075255034a1a84506b778381ab59dd84903c6c211a23f9e2f0d456f2b
      linux: sha256=e407566e2063ac697e0bbf6f2dd334be448d58bed93f44a186408bf1fc54c552
  godot:
    version: 3.0.2
