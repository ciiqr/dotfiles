{% import "macros/primary.sls" as primary with context %}

{{ sls }}.pkg.kitty:
  pkg.installed:
    - name: caskroom/cask/kitty

# TODO: configure and decide if I like it over plain terminal
