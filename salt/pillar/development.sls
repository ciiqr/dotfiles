
development:
  git:
    config:
      user.name: William Villeneuve
      push.default: simple
      pull.rebase: "'true'"
      color.ui: "'true'"
      # TODO: Reconsider core.pager 'less'

      alias.cm: "'!git commit -m'"
      alias.st: status
      alias.co: checkout
      alias.br: branch

  hashicorp:
    platform_map:
      # osx: darwin
      linux: linux
    arch_map:
      x86_64: amd64
  vagrant:
    version: 1.9.0
  terraform:
    version: 0.10.8
  packer:
    version: 1.1.1
