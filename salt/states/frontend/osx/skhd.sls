{% import "macros/primary.sls" as primary with context %}

# skhd
{{ sls }}.pkg.skhd:
  pkg.installed:
    - name: koekeishiya/formulae/skhd
    - taps: koekeishiya/formulae

# TODO: might need to restart on config changes?
{{ sls }}.svc.skhd:
  cmd.run:
  - name: brew services start skhd
  - onchanges:
    - pkg: {{ sls }}.pkg.skhd
