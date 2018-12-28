{% import "macros/pkg.sls" as pkg with context %}

{{ sls }}.service.lxdm:
  file.symlink:
    - target: /etc/sv/lxdm
    - name: /var/service/lxdm

# network
{{ sls }}.service.dhcpcd.purge:
  file.absent:
    - name: /var/service/dhcpcd

{{ sls }}.service.NetworkManager:
  file.symlink:
    - target: /etc/sv/NetworkManager
    - name: /var/service/NetworkManager
