{% set id = salt['grains.get']('id', '') %}
{% set platform = salt['grains.get']('platform', '') %}
{% set os_family = salt['grains.get']('os_family', '') %}
{% set os = salt['grains.get']('os', '') %}
{% set roles = salt['grains.get']('roles', []) %}

{% macro option(data, name) %}
{%- if name in data -%}
- {{ name }}: {{ data[name] | yaml }}
{%- endif -%}
{% endmacro %}

{% macro platform_includes() -%}
  - private.{{ sls }}
  - .{{ os_family }}
  - private.{{ sls }}.{{ os_family }}
  {% if os != os_family -%}
  - .{{ os }}
  - private.{{ sls }}.{{ os }}
  {%- endif %}
{% endmacro %}

{% macro os_family_includes() -%}
  - private.{{ sls }}
  {% if os != os_family -%}
  - .{{ os }}
  - private.{{ sls }}.{{ os }}
  {%- endif %}
{% endmacro %}

{% macro os_includes() -%}
  - private.{{ sls }}
{% endmacro %}

{% macro role_includes() -%}
  - private.{{ sls }}
  - .{{ platform }}
  - private.{{ sls }}.{{ platform }}
  - .{{ os_family }}
  - private.{{ sls }}.{{ os_family }}
  {% if os != os_family -%}
  - .{{ os }}
  - private.{{ sls }}.{{ os }}
  {%- endif %}
  - .{{ id }}
  - private.{{ sls }}.{{ id }}
{% endmacro %}

{% macro id_includes() -%}
  - private.{{ sls }}
  - .{{ platform }}
  - private.{{ sls }}.{{ platform }}
  - .{{ os_family }}
  - private.{{ sls }}.{{ os_family }}
  {% if os != os_family -%}
  - .{{ os }}
  - private.{{ sls }}.{{ os }}
  {%- endif %}
{% endmacro %}
