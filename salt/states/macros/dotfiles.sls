{% import "macros/primary.sls" as primary with context %}
{% from "macros/common.sls" import platform with context %}

{% macro link_static(source = '/home', destination = '') -%}
  {%- for configPath in [grains['configDir'] ~ '/salt/states/', grains['privateConfigDir'] ~ '/salt/states/private/'] -%}
    {%- set path = configPath ~ slspath ~ source -%}
    {%- set files = salt['file.find'](path, type='f') -%}
    {%- for file in files -%}
      {%- set relative_file = salt['utils.relpath'](file, path) -%}
      {%- set user_relative_file = primary.home() ~ '/' ~ destination ~ relative_file %}

{{ sls }}.~/{{ destination }}{{ relative_file }}:
  file.symlink:
    - name: {{ user_relative_file }}
    - target: {{ file }}
    - user: {{ primary.user() }}
    {% if not platform == 'windows' %}
    - group: {{ primary.group() }}
    {% endif %}
    - makedirs: true
    - force: true

    {% endfor -%}
  {%- endfor -%}
{%- endmacro %}
