{% import "macros/primary.sls" as primary with context %}

{{ sls }}.CreateDesktop:
  macdefaults.write:
    - name: CreateDesktop
    - domain: com.apple.finder
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

{{ sls }}.BackupTabState:
  macdefaults.write:
    - name: BackupTabState
    - domain: com.apple.finder
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

{{ sls }}.NewWindowTarget:
  macdefaults.write:
    - name: NewWindowTarget
    - domain: com.apple.finder
    - value: PfLo
    - vtype: string
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

{{ sls }}.NewWindowTargetPath:
  macdefaults.write:
    - name: NewWindowTargetPath
    - domain: com.apple.finder
    - value: file://{{ primary.home() }}
    - vtype: string
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder


{{ sls }}.NetBIOSName:
  macdefaults.write:
    - name: NetBIOSName
    - domain: /Library/Preferences/SystemConfiguration/com.apple.smb.server
    - value: {{ grains['system_serialnumber'] }}
    - vtype: string


{{ sls }}.mru-spaces:
  macdefaults.write:
    - name: mru-spaces
    - domain: com.apple.dock
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}
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
    - user: {{ primary.user() }}
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
