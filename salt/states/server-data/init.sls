{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/root.sls" as root with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/service.sls" as service with context %}
{% from "macros/common.sls" import role_includes with context %}

{% set server_data = pillar.get('server-data', {}) %}

{% call optional.include() %}
  {{ role_includes() }}
{%- endcall %}

{% call pkg.all_installed() %}
  - docker
{% endcall %}

{{ dotfiles.link_static() }}

# TODO: create compose file, inject secrets
