git:
  config:
    user.name: William Villeneuve
    push.default: simple
    pull.rebase: 'true'
    color.ui: 'true'
    rerere.enabled: 'true'
    diff.renames: 'copies' # Detect copies as well as renames
    init.defaultBranch: main
    pretty.mono: format:%C(yellow)%h%C(reset) %s%C(bold red)%d%C(reset) %C(green)%ad%C(reset) %C(blue)[%an]%C(reset)

    # TODO: figure out how to write:
    # git config --global url."git@github.com:".insteadOf "https://github.com/"

    # gpg
    gpg.program: gpg
    commit.gpgsign: 'true'

    # aliases
    alias.cm: '!git commit -m'
    alias.new: '!cd -- ${GIT_PREFIX:-.};~/.scripts/git.sh new' # ie. git config --global alias.new '!f() { git checkout -b "$1";git push -u origin "$1"; }; f'
    alias.cmb: '!cd -- ${GIT_PREFIX:-.};~/.scripts/git.sh cmb'
    alias.anp: '!cd -- ${GIT_PREFIX:-.};~/.scripts/git.sh anp'
    alias.anpa: '!~/.scripts/git.sh anpa'
    alias.alias: '!cd -- ${GIT_PREFIX:-.};~/.scripts/git.sh alias'
    alias.squash: '!cd -- ${GIT_PREFIX:-.};~/.scripts/git.sh squash'
    alias.st: status
    alias.co: '!cd -- ${GIT_PREFIX:-.};git checkout'
    alias.br: branch
    # diff
    alias.dcw: '!cd -- ${GIT_PREFIX:-.};git diff --cached -w'
    alias.dc: '!cd -- ${GIT_PREFIX:-.};git diff --cached'
    alias.dcow: '!cd -- ${GIT_PREFIX:-.};git diff --color-words'
    alias.dcwo: '!cd -- ${GIT_PREFIX:-.};git diff --cached --color-words'
    alias.d: '!cd -- ${GIT_PREFIX:-.};git diff'
    alias.diff-shortstat: '!cd -- ${GIT_PREFIX:-.};git diff --shortstat'
    # log
    alias.lp: '!cd -- ${GIT_PREFIX:-.};git log --color --pretty=mono --relative-date --decorate'
    # assume-unchanged
    alias.hide: '!cd -- ${GIT_PREFIX:-.};git update-index --assume-unchanged'
    alias.unhide: '!cd -- ${GIT_PREFIX:-.};git update-index --no-assume-unchanged'
    alias.hidden: '!cd -- ${GIT_PREFIX:-.};git ls-files -v | grep "^[[:lower:]]" | cut -d" " -f2'
    # misc
    alias.contributors: '!git shortlog -s -n -e'
