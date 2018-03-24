{% import "macros/primary.sls" as primary with context %}

{{ sls }}.karabiner-elements:
  pkg.installed:
    - name: caskroom/cask/karabiner-elements
    - taps: caskroom/cask

{{ sls }}.karabiner.json:
  file.managed:
    - name: {{ primary.home() }}/.config/karabiner/karabiner.json
    - source: salt://{{ slspath }}/files/karabiner.json
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - mode: 644
    - require:
      - pkg: {{ sls }}.karabiner-elements
