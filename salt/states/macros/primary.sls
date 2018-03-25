{% macro user() -%}
  {{ grains['primaryUser'] }}
{%- endmacro %}

{% macro home() -%}
  {{ salt['user.info'](grains['primaryUser'])['home'] }}
{%- endmacro %}

{% macro group() -%}
  {{ salt['user.primary_group'](grains['primaryUser']) or grains['primaryUser'] }}
{%- endmacro %}

{% macro uid() -%}
  {{ salt['user.info'](grains['primaryUser'])['uid'] }}
{%- endmacro %}
