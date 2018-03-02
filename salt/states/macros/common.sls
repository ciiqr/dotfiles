{% set platform = salt['grains.get']('platform', '') %}
{% set os_family = salt['grains.get']('os_family', '') %}
{% set os = salt['grains.get']('os', '') %}
{% set roles = salt['grains.get']('roles', []) %}

{% macro option(data, name) %}
{%- if name in data -%}
- {{ name }}: {{ data[name] | yaml }}
{%- endif -%}
{% endmacro %}
