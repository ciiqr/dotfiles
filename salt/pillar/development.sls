
development:
  git:
    config:
      user.name: William Villeneuve
      push.default: simple
      pull.rebase: "'true'"
      color.ui: "'true'"
      rerere.enabled: "'true'"
      # TODO: Reconsider core.pager 'less'

      alias.cm: "'!git commit -m'"
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
    version: 0.11.9
    hash_map:
      osx: sha256=1b5a0c916f547c396959b8c303f3bfa7a2e936c78f002bf42e532c9254fd6d75
      linux: sha256=5d674e7b83945c37f7f14d0e4f655787dad86ba15b26e185604aa0c3812394ab
  packer:
    version: 1.1.1
    hash_map:
      osx: sha256=8f8a043075255034a1a84506b778381ab59dd84903c6c211a23f9e2f0d456f2b
      linux: sha256=e407566e2063ac697e0bbf6f2dd334be448d58bed93f44a186408bf1fc54c552
  godot:
    version: 3.0.2
