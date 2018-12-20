
# services
{{ sls }}.service.docker:
  file.symlink:
    - target: /etc/sv/docker
    - name: /var/service/docker
