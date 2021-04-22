{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}

{{ dotfiles.link_static() }}

# Browser
{{ sls }}.default-web-browser:
  xdg_settings.present:
    - name: default-web-browser
    - value: google-chrome.desktop
    - user: {{ primary.user() }}
    - requires:
      - pkg: frontend.pkg.xdg-open

# TODO: this should really rely on spacefm being installed, other's aswell
# File manager
{{ sls }}.file-manager:
  xdg_mime.present:
    - name: inode/directory
    - value: spacefm.desktop
    - user: {{ primary.user() }}
    - requires:
      - pkg: frontend.pkg.xdg-open

# PDF
# TODO: clean up
{% set evince_desktop = pillar.get('default_programs', {}).get('evince', {}).get('desktop', 'evince.desktop') %}
{{ sls }}.pdf-viewer:
  xdg_mime.present:
    - name: application/pdf
    - value: {{ evince_desktop }}
    - user: {{ primary.user() }}
    - requires:
      - pkg: frontend.pkg.xdg-open

# Image viewer
{{ sls }}.image/jpeg:
  xdg_mime.present:
    - name: image/jpeg
    - value: gpicview.desktop
    - user: {{ primary.user() }}
    - requires:
      - pkg: frontend.pkg.xdg-open

{{ sls }}.image/gif:
  xdg_mime.present:
    - name: image/gif
    - value: gpicview.desktop
    - user: {{ primary.user() }}
    - requires:
      - pkg: frontend.pkg.xdg-open

{{ sls }}.image/png:
  xdg_mime.present:
    - name: image/png
    - value: gpicview.desktop
    - user: {{ primary.user() }}
    - requires:
      - pkg: frontend.pkg.xdg-open

{{ sls }}.image/svg+xml:
  xdg_mime.present:
    - name: image/svg+xml
    - value: gpicview.desktop
    - user: {{ primary.user() }}
    - requires:
      - pkg: frontend.pkg.xdg-open

{{ sls }}.image/tiff:
  xdg_mime.present:
    - name: image/tiff
    - value: gpicview.desktop
    - user: {{ primary.user() }}
    - requires:
      - pkg: frontend.pkg.xdg-open

# Text editor
{{ sls }}.text/plain:
  xdg_mime.present:
    - name: text/plain
    - value: sublime_text_3.desktop
    - user: {{ primary.user() }}
    - requires:
      - pkg: frontend.pkg.sublime

{{ sls }}.text/xml:
  xdg_mime.present:
    - name: text/xml
    - value: sublime_text_3.desktop
    - user: {{ primary.user() }}
    - requires:
      - pkg: frontend.pkg.sublime

{{ sls }}.text/x-c:
  xdg_mime.present:
    - name: text/x-c
    - value: sublime_text_3.desktop
    - user: {{ primary.user() }}
    - requires:
      - pkg: frontend.pkg.sublime

{{ sls }}.sublime.prevent-upgrade-prompt:
  host.present:
    - name: www.sublimetext.com
    - ip: 0.0.0.0
