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
    gpg.program: gpg
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
    # TODO: test this alias and build the command for it:
    # - squash = "!f(){ git reset --soft HEAD~${1} && git commit --edit -m\"$(git log --format=%B --reverse HEAD..HEAD@{1})\" --no-verify; };f"
    # TODO: maybe rename, maybe wrap it into squash as a validation step and so we don't need two commands
    # TODO: if commit count shown doesn't match, may be a hint that the squash number is too high
    # TODO: fix:
    # - squash-preview = "!f(){ git show --color --pretty=format:"%C(yellow)%h%C(reset) %s%C(bold red)%d%C(reset) %C(green)%ad%C(reset) %C(blue)[%an]%C(reset)" --relative-date --decorate --name-status HEAD...HEAD~${1}; };f"
    # TODO: figure out how to write:
    # git config --global url."git@github.com:".insteadOf "https://github.com/"
    alias.st: status
    alias.co: '!cd -- ${GIT_PREFIX:-.};git checkout'
    alias.br: branch
    alias.dcw: '!cd -- ${GIT_PREFIX:-.};git diff --cached -w'
    alias.dc: '!cd -- ${GIT_PREFIX:-.};git diff --cached'
    alias.dcow: '!cd -- ${GIT_PREFIX:-.};git diff --color-words'
    alias.dcwo: '!cd -- ${GIT_PREFIX:-.};git diff --cached --color-words'
    alias.d: '!cd -- ${GIT_PREFIX:-.};git diff'
    alias.lp: '!cd -- ${GIT_PREFIX:-.};git log --color --pretty=format:"%C(yellow)%h%C(reset) %s%C(bold red)%d%C(reset) %C(green)%ad%C(reset) %C(blue)[%an]%C(reset)" --relative-date --decorate'
    alias.contributors: '!git shortlog -s -n -e'
    # TODO: git config --global alias.alias 'config --get-regexp ^alias\\.'
    # TODO: change to a function with optional parameter to specify the name of the alias to show
    alias.alias: 'config --get-regexp ^alias\\.'
    # TODO: fix
    # git add -A; git cm "debug"; git push;
    # git config --global alias.debug '!f() { git add -A; git cm "debug"; git push; }; f'

    # TODO:
    # git config --global alias.anp '!f() { cd -- ${GIT_PREFIX:-.}; git add -N "$@"; git add -p "$@"; }; f'
    # alias.anp: '!f() { cd -- ${GIT_PREFIX:-.}; git add -N "$@"; git add -p "$@"; }; f'
