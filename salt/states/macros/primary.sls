{% macro user() -%}
  {{ grains['primaryUser'] }}
{%- endmacro %}

{% macro home() -%}
  {{ salt['user.info'](grains['primaryUser'])['home'] }}
{%- endmacro %}

{% macro group() -%}
  {%- if 'user.primary_group' in salt -%}
  {{ salt['user.primary_group'](grains['primaryUser']) or grains['primaryUser'] }}
  {%- else -%}
  {{ grains['primaryUser'] }}
  {%- endif -%}
{%- endmacro %}

{% macro uid() -%}
  {{ salt['user.info'](grains['primaryUser'])['uid'] }}
{%- endmacro %}
