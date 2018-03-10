{% import "macros/optional.sls" as optional with context %}
{% from "macros/common.sls" import role_includes with context %}

{% set default = salt['pillar.get']('default', grains['id']) %}

{% call optional.include() %}
  {{ role_includes() }}
{%- endcall %}

{{ sls }}.hostname:
  hostname.system:
    - name: {{ default.get('hostname', grains['id']) }}
