{% import "macros/dotfiles.sls" as dotfiles with context %}

{{ dotfiles.link_static() }}

# Browser
{{ sls }}.default-web-browser:
  xdg_settings.present:
    - name: default-web-browser
    - value: firefox.desktop

# File manager
{{ sls }}.file-manager:
  xdg_mime.present:
    - name: inode/directory
    - value: spacefm.desktop

# PDF
{{ sls }}.pdf-viewer:
  xdg_mime.present:
    - name: application/pdf
    - value: evince.desktop

# Image viewer
{{ sls }}.image/jpeg:
  xdg_mime.present:
    - name: image/jpeg
    - value: gpicview.desktop

{{ sls }}.image/gif:
  xdg_mime.present:
    - name: image/gif
    - value: gpicview.desktop

{{ sls }}.image/png:
  xdg_mime.present:
    - name: image/png
    - value: gpicview.desktop

{{ sls }}.image/svg+xml:
  xdg_mime.present:
    - name: image/svg+xml
    - value: gpicview.desktop

{{ sls }}.image/tiff:
  xdg_mime.present:
    - name: image/tiff
    - value: gpicview.desktop
