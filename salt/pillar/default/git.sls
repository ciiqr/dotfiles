git:
  config:
    user.name: William Villeneuve
    push.default: simple
    pull.rebase: 'true'
    color.ui: 'true'
    rerere.enabled: 'true'
    diff.renames: 'copies' # Detect copies as well as renames
    # TODO: Reconsider core.pager 'less'
    init.defaultBranch: main

    # gpg
    gpg.program: gpg2
    commit.gpgsign: 'true'

    alias.cm: '!git commit -m'
    # TODO: change these more complex aliases to use a script (~/.scripts/git.sh), this way they're not so fragile and I don't need to worry about fixing the syntax here
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
    alias.dcow: '!git diff --color-words'
    alias.dcwo: '!git diff --cached --color-words'
    alias.d: 'diff'
    alias.lp: '!git log --color --pretty=format:"%C(yellow)%h%C(reset) %s%C(bold red)%d%C(reset) %C(green)%ad%C(reset) %C(blue)[%an]%C(reset)" --relative-date --decorate'
    alias.contributors: '!git shortlog -s -n -e'
    # TODO: git config --global alias.alias 'config --get-regexp ^alias\\.'
    alias.alias: 'config --get-regexp ^alias\\.'
    # TODO: fix
    # git add -A; git cm "debug"; git push;
    # git config --global alias.debug '!f() { git add -A; git cm "debug"; git push; }; f'
