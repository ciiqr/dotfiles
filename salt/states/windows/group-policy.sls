{{ sls }}.local-group-policy:
  lgpo.set:
    - computer_policy:
        # timeline in super + tab menu
        Enables Activity Feed: Disabled

        # Disable "Make available offline" for network drives
        Remove "Make Available Offline" command: Enabled
        Allow or Disallow use of the Offline Files feature: Disabled
    - user_policy:
        # don't hide items in system tray dropdown
        Turn off notification area cleanup: Enabled

        Turn off Aero Shake window minimizing mouse gesture: Enabled

        Remove "Recently added" list from Start Menu: Enabled

        # Unpin everything from start menu
        Start Layout:
          Start Layout File: {{ grains['configDir'] }}\salt\states\{{ slspath }}\files\layout.xml
