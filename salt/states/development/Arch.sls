# services

{{ sls }}.service.docker:
  service.enabled:
    - name: docker
