{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/root.sls" as root with context %}

# TODO: do I even need this?... probs not
# {{ sls }}.xbps-alternatives-locate:
#   cmd.run:
#     - name: sudo xbps-alternatives -s mlocate -g locate
#     - require:
#       - base.pkg.mlocate

{{ sls }}.service.ntpd:
  file.symlink:
    - target: /etc/sv/ntpd
    - name: /var/service/ntpd

{{ sls }}.service.dbus:
  file.symlink:
    - target: /etc/sv/dbus
    - name: /var/service/dbus

{{ sls }}.service.haveged:
  file.symlink:
    - target: /etc/sv/haveged
    - name: /var/service/haveged
