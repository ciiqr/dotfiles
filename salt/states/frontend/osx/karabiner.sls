{% import "macros/primary.sls" as primary with context %}

{{ sls }}.karabiner-elements:
  pkg.installed:
    - name: homebrew/cask/karabiner-elements
    - taps: homebrew/cask

{{ sls }}.karabiner.json:
  file.managed:
    - name: {{ primary.home() }}/.config/karabiner/karabiner.json
    - source: salt://{{ slspath }}/files/karabiner.json
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - makedirs: true
    - mode: 644
    - require:
      - pkg: {{ sls }}.karabiner-elements
