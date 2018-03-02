{% import "macros/optional.sls" as optional with context %}
{% from "macros/common.sls" import platform, roles, id with context %}

base:
  {% call optional.high_states('default') %}
  '*':
  {%- endcall %}

  {% call optional.high_states(platform) %}
  'platform:{{ platform }}':
    - match: grain
  {%- endcall %}

  {% for role in roles -%}
  {% call optional.high_states(role) %}
  'roles:{{ role }}':
    - match: grain
  {%- endcall %}
  {% endfor -%}

  {% call optional.high_states(id) %}
  '{{ id }}':
  {%- endcall %}
