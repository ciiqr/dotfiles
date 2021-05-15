{% import "macros/primary.sls" as primary with context %}

# yabai
{{ sls }}.pkg.yabai:
  pkg.installed:
    - name: koekeishiya/formulae/yabai
    - taps: koekeishiya/formulae

# TODO: might need to restart on config changes?
{{ sls }}.svc.yabai:
  cmd.run:
  - name: brew services start yabai
  - runas: {{ primary.user() }}
  - onchanges:
    - pkg: {{ sls }}.pkg.yabai

{{ sls }}.install-sa:
  cmd.run:
  - name: yabai --install-sa
  - onchanges:
    - pkg: {{ sls }}.pkg.yabai
