{% import "macros/pkg.sls" as pkg with context %}

{{ sls }}.service.lxdm:
  file.symlink:
    - target: /etc/sv/lxdm
    - name: /var/service/lxdm
