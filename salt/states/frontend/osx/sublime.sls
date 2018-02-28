{% import "macros/primary.sls" as primary with context %}

{{ sls }}.~/.local/bin/subl3:
  file.symlink:
    - name: {{ primary.home() }}/.local/bin/subl3
    - target: /Applications/Sublime Text.app/Contents/SharedSupport/bin/subl
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - makedirs: true
    - force: true
    - require:
      - pkg: frontend.pkg.sublime
