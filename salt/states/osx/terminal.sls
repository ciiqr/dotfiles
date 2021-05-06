{% import "macros/primary.sls" as primary with context %}

{{ sls }}.theme:
  cmd.script:
    - source: salt://{{ slspath }}/files/terminal-theme.sh
    - name: terminal-theme.sh mine {{ grains['configDir'] }}/salt/states/{{ slspath }}/files/mine.terminal
    - runas: {{ primary.user() }}
    - stateful: true
