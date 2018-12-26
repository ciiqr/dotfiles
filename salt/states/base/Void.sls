{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/root.sls" as root with context %}

# TODO: do I even need this?... probs not
# {{ sls }}.xbps-alternatives-locate:
#   cmd.run:
#     - name: sudo xbps-alternatives -s mlocate -g locate
#     - require:
#       - base.pkg.mlocate

# services
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

{{ sls }}.service.dhcpcd.purge:
  file.absent:
    - name: /var/service/dhcpcd

{{ sls }}.service.NetworkManager:
  file.symlink:
    - target: /etc/sv/NetworkManager
    - name: /var/service/NetworkManager

# TODO: might make sense to live elsewhere
# bootloader
{{ sls }}.grub.config.GRUB_TIMEOUT:
  file.replace:
    - name: /etc/default/grub
    - pattern: ^[ \t]*GRUB_TIMEOUT[ \t]*=[ \t]*(.*)
    - repl: GRUB_TIMEOUT=1
    - append_if_not_found: true
    - onchanges_in:
      - cmd: {{ sls }}.grub.update-config

{{ sls }}.grub.config.GRUB_SAVEDEFAULT:
  file.replace:
    - name: /etc/default/grub
    - pattern: ^[ \t]*GRUB_SAVEDEFAULT[ \t]*=[ \t]*(.*)
    - repl: GRUB_SAVEDEFAULT=true
    - append_if_not_found: true
    - onchanges_in:
      - cmd: {{ sls }}.grub.update-config

{{ sls }}.grub.config.GRUB_DEFAULT:
  file.replace:
    - name: /etc/default/grub
    - pattern: ^[ \t]*GRUB_DEFAULT[ \t]*=[ \t]*(.*)
    - repl: GRUB_DEFAULT=saved
    - append_if_not_found: true
    - onchanges_in:
      - cmd: {{ sls }}.grub.update-config

{{ sls }}.grub.update-config:
  cmd.run:
    - name: grub-mkconfig -o /boot/grub/grub.cfg

# TODO: figure out a state for anacron...
# crons
{{ sls }}.xlocate.update:
  cron.present:
    - name: xlocate -S
    - hour: 20 # every day at 8pm
    - identifier: xlocate.update
