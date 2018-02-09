
{{ sls }}.command-line-tools:
  cmd.run:
    - name: xcode-select --install
    - runas: {{ grains['primaryUser'] }}
    - unless: xcode-select -p

{{ sls }}.brew:
  cmd.run:
    - name: echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    - runas: {{ grains['primaryUser'] }}
    - require:
      - {{ sls }}.command-line-tools
