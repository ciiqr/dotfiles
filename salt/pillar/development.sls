
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
    version: 0.10.8
    hash_map:
      osx: sha256=3f05acdf0a9e04ba7e3bda18521feb0b310462dcce62c454854a40519b1695ed
      linux: sha256=b786c0cf936e24145fad632efd0fe48c831558cc9e43c071fffd93f35e3150db
  packer:
    version: 1.1.1
    hash_map:
      osx: sha256=8f8a043075255034a1a84506b778381ab59dd84903c6c211a23f9e2f0d456f2b
      linux: sha256=e407566e2063ac697e0bbf6f2dd334be448d58bed93f44a186408bf1fc54c552
  godot:
    version: 3.0.2
