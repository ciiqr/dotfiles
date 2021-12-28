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
    pretty.mono: format:%C(yellow)%h%C(reset) %s%C(bold red)%d%C(reset) %C(green)%ad%C(reset) %C(blue)[%an]%C(reset)

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
    #   git cm "$(git branch --show-current): $1" "${@:2}"; \
    # }; f'

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
    alias.diff-shortstat: '!cd -- ${GIT_PREFIX:-.};git diff --shortstat'
    alias.lp: '!cd -- ${GIT_PREFIX:-.};git log --color --pretty=mono --relative-date --decorate'
    alias.contributors: '!git shortlog -s -n -e'
    # TODO: git config --global alias.alias 'config --get-regexp ^alias\\.'
    # TODO: change to a function with optional parameter to specify the name of the alias to show
    alias.alias: 'config --get-regexp ^alias\\.'
    # TODO: fix
    # git add -A; git cm "debug"; git push;
    # git config --global alias.debug '!f() { git add -A; git cm "debug"; git push; }; f'

    # TODO: some bug was causing `git anp .` to add a bunch of weird files in lane-services
    # git config --global alias.anp '!f() { cd -- "${GIT_PREFIX:-.}"; git -c "advice.addEmptyPathspec=false" add -N --ignore-removal "$@"; git add -p "$@"; }; f'
    # alias.anp: '!f() { cd -- ${GIT_PREFIX:-.}; git add -N --ignore-removal "$@"; git add -p "$@"; }; f'

    alias.squash: '!cd -- ${GIT_PREFIX:-.};~/.scripts/git.sh squash'

    alias.hide: '!cd -- ${GIT_PREFIX:-.};git update-index --assume-unchanged'
    alias.unhide: '!cd -- ${GIT_PREFIX:-.};git update-index --no-assume-unchanged'
    alias.hidden: '!cd -- ${GIT_PREFIX:-.};git ls-files -v | grep "^[[:lower:]]" | cut -d" " -f2'
