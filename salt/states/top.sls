{% import "macros/optional.sls" as optional with context %}

base:
  {% call optional.high_states('default') %}
  '*':
  {%- endcall %}

  {% set platform = salt['grains.get']('platform', '') %}
  {% call optional.high_states(platform) %}
  'platform:{{ platform }}':
    - match: grain
  {%- endcall %}

  {% for role in salt['grains.get']('roles', []) -%}
  {% call optional.high_states(role) %}
  'roles:{{ role }}':
    - match: grain
  {%- endcall %}
  {% endfor -%}
