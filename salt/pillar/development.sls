
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

  vagrant:
    version: 1.9.0
  terraform:
    version: 0.10.8
    hash: sha256=b786c0cf936e24145fad632efd0fe48c831558cc9e43c071fffd93f35e3150db
  packer:
    version: 1.1.1
    hash: sha256=e407566e2063ac697e0bbf6f2dd334be448d58bed93f44a186408bf1fc54c552
