{% import "macros/primary.sls" as primary with context %}

# TODO: could potentially use these instead, but I'll still need to "open" my theme, and it's nice having it apply immediately...
# defaults write com.apple.Terminal "Startup Window Settings" -string mine
# defaults write com.apple.Terminal "Default Window Settings" -string mine

{{ sls }}.theme:
  cmd.script:
    - source: salt://{{ slspath }}/files/terminal-theme.sh
    - name: terminal-theme.sh mine {{ grains['configDir'] }}/salt/states/{{ slspath }}/files/mine.terminal
    - runas: {{ primary.user() }}
    - stateful: true
