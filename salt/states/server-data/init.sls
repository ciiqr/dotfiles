{% import "macros/primary.sls" as primary with context %}
{% import "macros/root.sls" as root with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/service.sls" as service with context %}

{% set server_data = pillar.get('server-data', {}) %}

{% call pkg.all_installed() %}
  - docker
{% endcall %}

# TODO: create compose file, inject secrets
