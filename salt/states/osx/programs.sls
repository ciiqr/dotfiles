{% import "macros/primary.sls" as primary with context %}

# TODO: maybe also move to frontend.osx
# TODO: waiting for: https://github.com/saltstack/salt/pull/45309
# {{ sls }}.karabiner-elements:
#   pkg.installed:
#     - name: caskroom/cask/karabiner-elements
#     - taps: caskroom/cask

# TODO: maybe move programs which have more than one state to their own file...
{{ sls }}.karabiner.json:
  file.managed:
    - name: {{ primary.home() }}/.config/karabiner/karabiner.json
    - source: salt://{{ slspath }}/files/karabiner.json
    - user: {{ grains['primaryUser'] }}
    - group: {{ primary.gid() }}
    - mode: 644
    # - require:
    #   - pkg: {{ sls }}.karabiner-elements

# TODO: consider copying profile to system (just need to be really sure it's not too dangerout): sudo '/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --copy-current-profile-to-system-default-profile
