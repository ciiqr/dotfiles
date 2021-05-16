# NOTE: view configured settings with: salt-call --local lgpo.get
{{ sls }}.local-group-policy:
  lgpo.set:
    - computer_policy:
        # timeline in super + tab menu
        Enables Activity Feed: Disabled

        # Disable "Make available offline" for network drives
        Remove "Make Available Offline" command: Enabled
        Allow or Disallow use of the Offline Files feature: Disabled

        # Windows Update
        Allow Automatic Updates immediate installation: Enabled
        Do not adjust default option to 'Install Updates and Shut Down' in Shut Down Windows dialog box: Enabled
        Enabling Windows Update Power Management to automatically wake up the system to install scheduled updates: Disabled
        No auto-restart with logged on users for scheduled automatic updates installations: Enabled
        Turn off auto-restart notifications for update installations: Enabled
        Turn off auto-restart for updates during active hours:
          Start: 7 AM
          End: 4 AM
        # TODO: Not sure how to specify this (I've tried a bunch of different ways), not sure if it's required with other settings though
        # Display options for update notifications: '2 – Turn off all notifications, including restart warnings'
        Windows Components\Windows Update\Configure Automatic Updates:
          Configure automatic updating: 4 - Auto download and schedule the install
          Scheduled install day: 7 - Every Saturday
          Scheduled install time: 05:00
          Install during automatic maintenance: false
          Install updates for other Microsoft products: false
          Every week: true
          First week of the month: false
          Second week of the month: false
          Third week of the month: false
          Fourth week of the month: false

    - user_policy:
        # don't hide items in system tray dropdown
        Turn off notification area cleanup: Enabled

        Turn off Aero Shake window minimizing mouse gesture: Enabled

        Remove "Recently added" list from Start Menu: Enabled

        # Configure pinned items for start menu and taskbar
        Start Layout:
          Start Layout File: {{ grains['configDir'] }}\salt\states\{{ slspath }}\files\layout.xml
