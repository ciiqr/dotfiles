
brew:
  cmd.run:
    - name: echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    - runas: {{ grains['primaryUser'] }}
# TODO: do I need to? xcode-select --install
