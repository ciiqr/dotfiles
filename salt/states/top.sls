{% import "macros/optional.sls" as optional with context %}
{% from "macros/common.sls" import platform, os_family, os, roles, id with context %}

base:
  '*':
    - default

  {% call optional.high_states(platform) %}
  'platform:{{ platform }}':
    - match: grain
  {%- endcall %}

  {% call optional.high_states(os_family) %}
  'os_family:{{ os_family }}':
    - match: grain
  {%- endcall %}

  {% if os != os_family -%}
  {% call optional.high_states(os) %}
  'os:{{ os }}':
    - match: grain
  {%- endcall %}
  {%- endif %}

  {% for role in roles -%}
  {% call optional.high_states(role) %}
  'roles:{{ role }}':
    - match: grain
  {%- endcall %}
  {% endfor -%}

  {% call optional.high_states(id) %}
  '{{ id }}':
  {%- endcall %}
