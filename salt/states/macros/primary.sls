{% macro user() -%}
  {{ grains['primaryUser'] }}
{%- endmacro %}

{% macro home() -%}
  {{ salt['user.info'](grains['primaryUser'])['home'] }}
{%- endmacro %}

{% macro group() -%}
  {%- set gid = salt['user.info'](grains['primaryUser'])['gid'] -%}
  {{ salt['grouputils.groupNameById'](gid) }}
{%- endmacro %}
