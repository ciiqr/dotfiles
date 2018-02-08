{% macro home() -%}
  {{ salt['user.info'](grains['primaryUser'])['home'] }}
{%- endmacro %}

{% macro gid() -%}
  {{ salt['user.info'](grains['primaryUser'])['gid'] }}
{%- endmacro %}
