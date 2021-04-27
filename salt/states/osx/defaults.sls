{% import "macros/primary.sls" as primary with context %}

{% set default = salt['pillar.get']('default', {}) %}

# % System and Menubar

# Hide user menu item
{{ sls }}.MultipleSessionEnabled:
  macdefaults.write:
    - name: MultipleSessionEnabled
    - domain: /Library/Preferences/.GlobalPreferences
    - value: false
    - vtype: bool
    - onchanges_in:
      - cmd: {{ sls }}.kill.SystemUIServer

# Disable dashboard
{{ sls }}.mcx-disabled:
  macdefaults.write:
    - name: mcx-disabled
    - domain: com.apple.dashboard
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

# Set network name
# TODO: was the serial thing a work specific change?
{{ sls }}.NetBIOSName:
  macdefaults.write:
    - name: NetBIOSName
    - domain: /Library/Preferences/SystemConfiguration/com.apple.smb.server
    - value: {{ grains['system_serialnumber'] }}
    - vtype: string

# Set Menubar Date Format
{{ sls }}.DateFormat:
  macdefaults.write:
    - name: DateFormat
    - domain: com.apple.menuextra.clock
    - value: 'EEE MMM d  h:mm a'
    - vtype: string
    - user: {{ primary.user() }}

# darkmode
{{ sls }}.AppleInterfaceStyle:
  macdefaults.write:
    - name: AppleInterfaceStyle
    - domain: NSGlobalDomain
    - value: Dark
    - vtype: string
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

# System Preferences > General > Accent color
#  Color    AppleAquaColorVariant AppleAccentColor
#    Red            1                   0
#    Orange         1                   1
#    Yellow         1                   2
#    Green          1                   3
#    Purple         1                   5
#    Pink           1                   6
#    Blue           1                   deleted
#    Graphite       6                   -1
{{ sls }}.AppleAccentColor:
  macdefaults.write:
    - name: AppleAccentColor
    - domain: NSGlobalDomain
    - value: 3
    - vtype: int
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock
{{ sls }}.AppleAquaColorVariant:
  macdefaults.write:
    - name: AppleAquaColorVariant
    - domain: NSGlobalDomain
    - value: 1
    - vtype: int
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

# System Preferences > General > Highlight color
# Color    AppleHighlightColor
# Red      "1.000000 0.733333 0.721569 Red"
# Orange   "1.000000 0.874510 0.701961 Orange"
# Yellow   "1.000000 0.937255 0.690196 Yellow"
# Green    "0.752941 0.964706 0.678431 Green"
# Purple   "0.968627 0.831373 1.000000 Purple"
# Pink     "1.000000 0.749020 0.823529 Pink"
# Blue     deleted
# Graphite "0.847059 0.847059 0.862745 Graphite"
{{ sls }}.AppleHighlightColor:
  macdefaults.write:
    - name: AppleHighlightColor
    - domain: NSGlobalDomain
    - value: '0.752941 0.964706 0.678431 Green'
    - vtype: string
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

# Increase window resize speed for Cocoa applications
{{ sls }}.NSWindowResizeTime:
  macdefaults.write:
    - name: NSWindowResizeTime
    - domain: NSGlobalDomain
    - value: 0.001
    - vtype: float
    - user: {{ primary.user() }}

# Expand save panel by default
{{ sls }}.NSNavPanelExpandedStateForSaveMode:
  macdefaults.write:
    - name: NSNavPanelExpandedStateForSaveMode
    - domain: NSGlobalDomain
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
{{ sls }}.NSNavPanelExpandedStateForSaveMode2:
  macdefaults.write:
    - name: NSNavPanelExpandedStateForSaveMode2
    - domain: NSGlobalDomain
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}

# Save to disk (not to iCloud) by default
{{ sls }}.NSDocumentSaveNewDocumentsToCloud:
  macdefaults.write:
    - name: NSDocumentSaveNewDocumentsToCloud
    - domain: NSGlobalDomain
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}

# Disable the “Are you sure you want to open this application?” dialog
{{ sls }}.LSQuarantine:
  macdefaults.write:
    - name: LSQuarantine
    - domain: com.apple.LaunchServices
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}

# Disable automatic termination of inactive apps
{{ sls }}.NSDisableAutomaticTermination:
  macdefaults.write:
    - name: NSDisableAutomaticTermination
    - domain: NSGlobalDomain
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}

# Disable animations when opening and closing windows.
{{ sls }}.NSAutomaticWindowAnimationsEnabled:
  macdefaults.write:
    - name: NSAutomaticWindowAnimationsEnabled
    - domain: NSGlobalDomain
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}

# Set sidebar icon size to medium
{{ sls }}.NSTableViewDefaultSizeMode:
  macdefaults.write:
    - name: NSTableViewDefaultSizeMode
    - domain: NSGlobalDomain
    - value: 2
    - vtype: int
    - user: {{ primary.user() }}

# Always show scrollbars
{{ sls }}.AppleShowScrollBars:
  macdefaults.write:
    - name: AppleShowScrollBars
    - domain: NSGlobalDomain
    - value: Always
    - vtype: string
    - user: {{ primary.user() }}

# Disable the over-the-top focus ring animation
{{ sls }}.NSUseAnimatedFocusRing:
  macdefaults.write:
    - name: NSUseAnimatedFocusRing
    - domain: NSGlobalDomain
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}

# Adjust toolbar title rollover delay
{{ sls }}.NSToolbarTitleViewRolloverDelay:
  macdefaults.write:
    - name: NSToolbarTitleViewRolloverDelay
    - domain: NSGlobalDomain
    - value: 0
    - vtype: float
    - user: {{ primary.user() }}

# Disable Resume system-wide
{{ sls }}.NSQuitAlwaysKeepsWindows:
  macdefaults.write:
    - name: NSQuitAlwaysKeepsWindows
    - domain: com.apple.systempreferences
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}

# Context menu item for showing the Web Inspector in web views
{{ sls }}.WebKitDeveloperExtras:
  macdefaults.write:
    - name: WebKitDeveloperExtras
    - domain: NSGlobalDomain
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}


# % System updates

# Enable the automatic update check
{{ sls }}.AutomaticCheckEnabled:
  macdefaults.write:
    - name: AutomaticCheckEnabled
    - domain: com.apple.SoftwareUpdate
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}

# Check for software updates daily, not just once per week
{{ sls }}.ScheduleFrequency:
  macdefaults.write:
    - name: ScheduleFrequency
    - domain: com.apple.SoftwareUpdate
    - value: 1
    - vtype: int
    - user: {{ primary.user() }}

# Download newly available updates in background
{{ sls }}.AutomaticDownload:
  macdefaults.write:
    - name: AutomaticDownload
    - domain: com.apple.SoftwareUpdate
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}

# Install System data files & security updates
{{ sls }}.CriticalUpdateInstall:
  macdefaults.write:
    - name: CriticalUpdateInstall
    - domain: com.apple.SoftwareUpdate
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}

# Automatically download apps purchased on other Macs
{{ sls }}.ConfigDataInstall:
  macdefaults.write:
    - name: ConfigDataInstall
    - domain: com.apple.SoftwareUpdate
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}

# Turn on app auto-update
{{ sls }}.AutoUpdate:
  macdefaults.write:
    - name: AutoUpdate
    - domain: com.apple.commerce
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}

# Allow the App Store to reboot machine on macOS updates
{{ sls }}.AutoUpdateRestartRequired:
  macdefaults.write:
    - name: AutoUpdateRestartRequired
    - domain: com.apple.commerce
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}


# % Bluetooth

# Increase sound quality for Bluetooth headphones/headsets
{{ sls }}.AppleBitpoolMin:
  macdefaults.write:
    - name: "Apple Bitpool Min (editable)"
    - domain: com.apple.BluetoothAudioAgent
    - value: 40
    - vtype: int
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.coreaudiod


# % Keyboard and input

# Enable full keyboard access for all controls (Tab between all ui elements)
{{ sls }}.AppleKeyboardUIMode:
  macdefaults.write:
    - name: AppleKeyboardUIMode
    - domain: NSGlobalDomain
    - value: 3
    - vtype: int
    - user: {{ primary.user() }}

# Disable press-and-hold for keys in favor of key repeat
{{ sls }}.ApplePressAndHoldEnabled:
  macdefaults.write:
    - name: ApplePressAndHoldEnabled
    - domain: NSGlobalDomain
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}

# Set a fast keyboard repeat rate
# NOTE: values based on my linux settings: xset r rate 400 20
# InitialKeyRepeat: 1 = 15ms
# (400/15) = 26.666666666666668 ~ 27
# KeyRepeat: 1 = 15ms
# (20/15) = 1.3333333333333333 ~ 1
{{ sls }}.KeyRepeat:
  macdefaults.write:
    - name: KeyRepeat
    - domain: NSGlobalDomain
    - value: 1
    - vtype: int
    - user: {{ primary.user() }}
{{ sls }}.InitialKeyRepeat:
  macdefaults.write:
    - name: InitialKeyRepeat
    - domain: NSGlobalDomain
    - value: 27
    - vtype: int
    - user: {{ primary.user() }}


# % Screen

# Enable subpixel font rendering on non-Apple LCDs
{{ sls }}.AppleFontSmoothing:
  macdefaults.write:
    - name: AppleFontSmoothing
    - domain: NSGlobalDomain
    - value: 1
    - vtype: int
    - user: {{ primary.user() }}


# % Finder

# Disable desktop icons
{{ sls }}.CreateDesktop:
  macdefaults.write:
    - name: CreateDesktop
    - domain: com.apple.finder
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Save state of last tab
{{ sls }}.BackupTabState:
  macdefaults.write:
    - name: BackupTabState
    - domain: com.apple.finder
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Allow custom default locations for new windows
{{ sls }}.NewWindowTarget:
  macdefaults.write:
    - name: NewWindowTarget
    - domain: com.apple.finder
    - value: PfLo
    - vtype: string
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# New windows open in home directory
{{ sls }}.NewWindowTargetPath:
  macdefaults.write:
    - name: NewWindowTargetPath
    - domain: com.apple.finder
    - value: file://{{ primary.home() }}
    - vtype: string
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Folders are listed first in any Finder window.
{{ sls }}._FXSortFoldersFirst:
  macdefaults.write:
    - name: _FXSortFoldersFirst
    - domain: com.apple.finder
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Finder: show all filename extensions (also in file save dialogs)
{{ sls }}.AppleShowAllExtensions:
  macdefaults.write:
    - name: AppleShowAllExtensions
    - domain: NSGlobalDomain
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Finder: show path bar
{{ sls }}.ShowPathbar:
  macdefaults.write:
    - name: ShowPathbar
    - domain: com.apple.finder
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Finder: allow text selection in Quick Look
{{ sls }}.QLEnableTextSelection:
  macdefaults.write:
    - name: QLEnableTextSelection
    - domain: com.apple.finder
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Display full POSIX path as Finder window title
{{ sls }}._FXShowPosixPathInTitle:
  macdefaults.write:
    - name: _FXShowPosixPathInTitle
    - domain: com.apple.finder
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# When performing a search, search the current folder by default
{{ sls }}.FXDefaultSearchScope:
  macdefaults.write:
    - name: FXDefaultSearchScope
    - domain: com.apple.finder
    - value: "SCcf"
    - vtype: string
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Disable the warning when changing a file extension
{{ sls }}.FXEnableExtensionChangeWarning:
  macdefaults.write:
    - name: FXEnableExtensionChangeWarning
    - domain: com.apple.finder
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Enable spring loading for directories
{{ sls }}.com.apple.springing.enabled:
  macdefaults.write:
    - name: com.apple.springing.enabled
    - domain: NSGlobalDomain
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Remove the spring loading delay for directories
{{ sls }}.com.apple.springing.delay:
  macdefaults.write:
    - name: com.apple.springing.delay
    - domain: NSGlobalDomain
    - value: 0
    - vtype: float
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Avoid creating .DS_Store files on network volumes
{{ sls }}.DSDontWriteNetworkStores:
  macdefaults.write:
    - name: DSDontWriteNetworkStores
    - domain: com.apple.desktopservices
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Avoid creating .DS_Store files on usb volumes
{{ sls }}.DSDontWriteUSBStores:
  macdefaults.write:
    - name: DSDontWriteUSBStores
    - domain: com.apple.desktopservices
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Automatically open a new Finder window when a volume is mounted
{{ sls }}.auto-open-ro-root:
  macdefaults.write:
    - name: auto-open-ro-root
    - domain: com.apple.frameworks.diskimages
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder
{{ sls }}.auto-open-rw-root:
  macdefaults.write:
    - name: auto-open-rw-root
    - domain: com.apple.frameworks.diskimages
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder
{{ sls }}.OpenWindowForNewRemovableDisk:
  macdefaults.write:
    - name: OpenWindowForNewRemovableDisk
    - domain: com.apple.finder
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
{{ sls }}.BrowseAllInterfaces:
  macdefaults.write:
    - name: BrowseAllInterfaces
    - domain: com.apple.NetworkBrowser
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Disable animation when opening the Info window in Finder (cmd⌘ + i).
{{ sls }}.DisableAllAnimations:
  macdefaults.write:
    - name: DisableAllAnimations
    - domain: com.apple.finder
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder

# Disable animations when opening a Quick Look window.
{{ sls }}.QLPanelAnimationDuration:
  macdefaults.write:
    - name: QLPanelAnimationDuration
    - domain: NSGlobalDomain
    - value: 0
    - vtype: float
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Finder


# % Dock

# Disable: Automatically rearrange Spaces based on most recent use
{{ sls }}.mru-spaces:
  macdefaults.write:
    - name: mru-spaces
    - domain: com.apple.dock
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

# Speed up Mission Control animations
{{ sls }}.expose-animation-duration:
  macdefaults.write:
    - name: expose-animation-duration
    - domain: com.apple.dock
    - value: 0.1
    - vtype: float
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

# Make Dock icons of hidden applications translucent
{{ sls }}.showhidden:
  macdefaults.write:
    - name: showhidden
    - domain: com.apple.dock
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

# Don’t show recent applications in Dock
{{ sls }}.show-recents:
  macdefaults.write:
    - name: show-recents
    - domain: com.apple.dock
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

# Disable the Launchpad gesture (pinch with thumb and three fingers)
{{ sls }}.showLaunchpadGestureEnabled:
  macdefaults.write:
    - name: showLaunchpadGestureEnabled
    - domain: com.apple.dock
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

# Set icon size
{{ sls }}.tilesize:
  macdefaults.write:
    - name: tilesize
    - domain: com.apple.dock
    - value: 10
    - vtype: int
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

# position left
{{ sls }}.orientation:
  macdefaults.write:
    - name: orientation
    - domain: com.apple.Dock
    - value: left
    - vtype: string
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

# lock size
{{ sls }}.size-immutable:
  macdefaults.write:
    - name: size-immutable
    - domain: com.apple.Dock
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

# Dock: Prefer tabs when opening documents: always, fullscreen, manual
{{ sls }}.AppleWindowTabbingMode:
  macdefaults.write:
    - name: AppleWindowTabbingMode
    - domain: NSGlobalDomain
    - value: always
    - vtype: string
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock

# Disable animations when you open an application from the Dock.
{{ sls }}.launchanim:
  macdefaults.write:
    - name: launchanim
    - domain: com.apple.dock
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.Dock


# % Terminal

# Only use UTF-8 in Terminal.app
{{ sls }}.StringEncodings:
  macdefaults.write:
    - name: StringEncodings
    - domain: com.apple.terminal
    - value: 4
    - vtype: array
    - user: {{ primary.user() }}

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
{{ sls }}.SecureKeyboardEntry:
  macdefaults.write:
    - name: SecureKeyboardEntry
    - domain: com.apple.terminal
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}

# Disable the annoying line marks
{{ sls }}.ShowLineMarks:
  macdefaults.write:
    - name: ShowLineMarks
    - domain: com.apple.Terminal
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}


# % Activity Monitor

# Show the main window when launching Activity Monitor
{{ sls }}.OpenMainWindow:
  macdefaults.write:
    - name: OpenMainWindow
    - domain: com.apple.ActivityMonitor
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.ActivityMonitor

# Show all processes in Activity Monitor
{{ sls }}.ShowCategory:
  macdefaults.write:
    - name: ShowCategory
    - domain: com.apple.ActivityMonitor
    - value: 100
    - vtype: int
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.ActivityMonitor

# Sort Activity Monitor results by CPU usage
{{ sls }}.SortColumn:
  macdefaults.write:
    - name: SortColumn
    - domain: com.apple.ActivityMonitor
    - value: CPUUsage
    - vtype: string
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.ActivityMonitor
{{ sls }}.SortDirection:
  macdefaults.write:
    - name: SortDirection
    - domain: com.apple.ActivityMonitor
    - value: 0
    - vtype: int
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.ActivityMonitor


# % TextEdit

# Use plain text mode for new TextEdit documents
{{ sls }}.RichText:
  macdefaults.write:
    - name: RichText
    - domain: com.apple.TextEdit
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}

# Open and save files as UTF-8 in TextEdit
{{ sls }}.PlainTextEncoding:
  macdefaults.write:
    - name: PlainTextEncoding
    - domain: com.apple.TextEdit
    - value: 4
    - vtype: int
    - user: {{ primary.user() }}
{{ sls }}.PlainTextEncodingForWrite:
  macdefaults.write:
    - name: PlainTextEncodingForWrite
    - domain: com.apple.TextEdit
    - value: 4
    - vtype: int
    - user: {{ primary.user() }}


# % Disk Utility

# Enable the debug menu in Disk Utility
{{ sls }}.DUDebugMenuEnabled:
  macdefaults.write:
    - name: DUDebugMenuEnabled
    - domain: com.apple.DiskUtility
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
{{ sls }}.advanced-image-options:
  macdefaults.write:
    - name: advanced-image-options
    - domain: com.apple.DiskUtility
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}


# % Photos

# Prevent Photos from opening automatically when devices are plugged in
{{ sls }}.disableHotPlug:
  macdefaults.write:
    - name: disableHotPlug
    - domain: com.apple.ImageCapture
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}


# % Google Chrome

# Disable the all too sensitive backswipe on trackpads
{{ sls }}.AppleEnableSwipeNavigateWithScrolls:
  macdefaults.write:
    - name: AppleEnableSwipeNavigateWithScrolls
    - domain: com.google.Chrome
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}


# % Safari

# Prevent Safari from opening ‘safe’ files automatically after downloading
{{ sls }}.AutoOpenSafeDownloads:
  macdefaults.write:
    - name: AutoOpenSafeDownloads
    - domain: com.apple.Safari
    - value: false
    - vtype: bool
    - user: {{ primary.user() }}


# % Screenshots

# Save screenshots to ~/Screenshots
{{ sls }}.screencapture.location:
  macdefaults.write:
    - name: location
    - domain: com.apple.screencapture
    - value: {{ primary.home() }}/Screenshots
    - vtype: string
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.SystemUIServer

# Include hostname in screenshot filenames
{{ sls }}.screencapture.name:
  macdefaults.write:
    - name: name
    - domain: com.apple.screencapture
    - value: {{ default.get('hostname', grains['id']) }}
    - vtype: string
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.SystemUIServer

# Include date in screenshot filenames
{{ sls }}.screencapture.include-date:
  macdefaults.write:
    - name: include-date
    - domain: com.apple.screencapture
    - value: true
    - vtype: bool
    - user: {{ primary.user() }}
    - onchanges_in:
      - cmd: {{ sls }}.kill.SystemUIServer


# % kill

{{ sls }}.kill.Finder:
  cmd.run:
    - name: killall 'Finder' &> /dev/null

{{ sls }}.kill.Dock:
  cmd.run:
    - name: killall 'Dock' &> /dev/null

{{ sls }}.kill.SystemUIServer:
  cmd.run:
    - name: killall 'SystemUIServer' &> /dev/null

{{ sls }}.kill.ActivityMonitor:
  cmd.run:
    - name: killall 'Activity Monitor' &> /dev/null

{{ sls }}.kill.coreaudiod:
  cmd.run:
    - name: killall 'coreaudiod' &> /dev/null
