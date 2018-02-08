
{{ sls }}.CreateDesktop:
  macdefaults.write:
    - name: CreateDesktop
    - domain: com.apple.finder
    - value: false
    - vtype: bool
    - user: {{ grains['primaryUser'] }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

{{ sls }}.kill.Finder:
  cmd.run:
    - name: killall 'Finder' &> /dev/null
