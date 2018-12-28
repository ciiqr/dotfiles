
{{ sls }}.service.dhcpcd:
  file.symlink:
    - target: /etc/sv/dhcpcd
    - name: /var/service/dhcpcd
