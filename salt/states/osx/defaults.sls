
{{ sls }}.CreateDesktop:
  macdefaults.write:
    - name: CreateDesktop
    - domain: com.apple.finder
    - value: false
    - vtype: bool
    - user: {{ grains['primaryUser'] }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

{{ sls }}.mru-spaces:
  macdefaults.write:
    - name: mru-spaces
    - domain: com.apple.dock
    - value: false
    - vtype: bool
    - user: {{ grains['primaryUser'] }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

{{ sls }}.MultipleSessionEnabled:
  macdefaults.write:
    - name: MultipleSessionEnabled
    - domain: /Library/Preferences/.GlobalPreferences
    - value: false
    - vtype: bool
    - onchanges_in:
      - cmd: {{ sls }}.kill.SystemUIServer

{{ sls }}.mcx-disabled:
  macdefaults.write:
    - name: mcx-disabled
    - domain: com.apple.dashboard
    - value: true
    - vtype: bool
    - user: {{ grains['primaryUser'] }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock


{{ sls }}.kill.Finder:
  cmd.run:
    - name: killall 'Finder' &> /dev/null

{{ sls }}.kill.Dock:
  cmd.run:
    - name: killall 'Dock' &> /dev/null

{{ sls }}.kill.SystemUIServer:
  cmd.run:
    - name: killall 'SystemUIServer' &> /dev/null
