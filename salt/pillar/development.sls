
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
