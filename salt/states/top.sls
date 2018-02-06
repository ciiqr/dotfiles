{% from "macros/optional.sls" import optional_high_states with context %}

base:
  {% call optional_high_states('default', 'private.default') %}
  '*':
  {%- endcall %}

  {% set platform = salt['grains.get']('platform', '') %}
  {% call optional_high_states(platform, 'private.' ~ platform) %}
  'platform:{{ platform }}':
    - match: grain
  {%- endcall %}

  {% for role in salt['grains.get']('roles', []) -%}
  {% call optional_high_states(role, 'private.' ~ role, role ~ '.' ~ platform, 'private.' ~ role ~ '.' ~ platform) %}
  'roles:{{ role }}':
    - match: grain
  {%- endcall %}
  {% endfor -%}
