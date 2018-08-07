{% import "macros/primary.sls" as primary with context %}

# packages
{{ sls }}.chunkwm:
  pkg.installed:
    - name: chunkwm
    - taps: crisidev/homebrew-chunkwm

{{ sls }}.skhd:
  pkg.installed:
    - name: skhd
    - taps: koekeishiya/formulae

# TODO: link plugins
# ln -s /usr/local/share/chunkwm/plugins/border.so ~/.chunkwm_plugins/border.so
# ln -s /usr/local/share/chunkwm/plugins/ffm.so ~/.chunkwm_plugins/ffm.so
# ln -s /usr/local/share/chunkwm/plugins/tiling.so ~/.chunkwm_plugins/tiling.so

# TODO: both services below require accessibility acces, is there a way for me to automate that
# TODO: need a brew services module/state
# - brew services start chunkwm
# - brew services start skhd

# {{ sls }}.brew_service.chunkwm:
#   brew_service.running:
#     - enable: True
#     - name: chunkwm

# {{ sls }}.brew_service.skhd:
#   brew_service.running:
#     - enable: True
#     - name: skhd
