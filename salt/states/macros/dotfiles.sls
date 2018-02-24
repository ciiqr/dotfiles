{% import "macros/primary.sls" as primary with context %}
{% import "macros/track.sls" as track with context %}

{% macro link_static() -%}
  {%- for statePath in [grains['configDir'], grains['privateConfigDir']] -%}
    {%- set path = statePath ~ '/salt/states/' ~ slspath ~ '/files/home' -%}
    {%- set files = salt['file.find'](path, type='f') -%}
    {%- for file in files -%}
      {%- set relative_file = salt['utils.relpath'](file, path) -%}
      {%- set user_relative_file = primary.home() ~ '/' ~ relative_file %}

{{ sls }}.~/{{ relative_file }}:
  file.symlink:
    - name: {{ user_relative_file }}
    - target: {{ file }}
    - makedirs: true

    {% endfor -%}
  {%- endfor -%}
{%- endmacro %}
