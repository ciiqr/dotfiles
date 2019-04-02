
development:
  git:
    config:
      user.name: William Villeneuve
      push.default: simple
      pull.rebase: 'true'
      color.ui: 'true'
      rerere.enabled: 'true'
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

  hashicorp:
    platform_map:
      osx: darwin
      linux: linux
    arch_map:
      x86_64: amd64
  vagrant:
    version: 2.0.3
  terraform:
    version: 0.11.10
    hash_map:
      osx: sha256=cb5ae1fa5bed45d81d79d427cd1dd84ed7c04f712c72b420003e28f522a77a78
      linux: sha256=43543a0e56e31b0952ea3623521917e060f2718ab06fe2b2d506cfaa14d54527
  packer:
    version: 1.1.1
    hash_map:
      osx: sha256=8f8a043075255034a1a84506b778381ab59dd84903c6c211a23f9e2f0d456f2b
      linux: sha256=e407566e2063ac697e0bbf6f2dd334be448d58bed93f44a186408bf1fc54c552
  godot:
    version: 3.0.2
