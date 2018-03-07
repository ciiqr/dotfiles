{% import "macros/optional.sls" as optional with context %}
{% from "macros/common.sls" import platform, roles with context %}

base:
  '*':
    - default

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
