{% import "macros/primary.sls" as primary with context %}

{{ sls }}.command-line-tools:
  cmd.run:
    - name: xcode-select --install
    - runas: {{ primary.user() }}
    - unless: xcode-select -p

{{ sls }}.brew:
  cmd.run:
    - name: echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    - runas: {{ primary.user() }}
    - require:
      - {{ sls }}.command-line-tools
