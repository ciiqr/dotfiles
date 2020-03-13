chocolatey.bootstrap: module.run

# remove all pinned items
# TODO: ultimately this would be better of as a layout.xml than I can import with Import-StartLayout, but I've found it doesn't work consistently, so more testing is needed
# TODO: if nothing else though, we can probably make this stateful pretty easily
remove_all_pins:
  cmd.script:
    # - source: salt://windows/files/remove-all-pins.ps1
    - source: salt://windows/files/remove-all-pins.ps1
    - shell: powershell
