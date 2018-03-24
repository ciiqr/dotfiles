{% macro user() -%}
  {{ 'root' }}
{%- endmacro %}

{% macro home() -%}
  {{ salt['user.info']('root')['home'] }}
{%- endmacro %}

{% macro group() -%}
  {{ salt['user.primary_group']('root') }}
{%- endmacro %}

{% macro uid() -%}
  {{ salt['user.info']('root')['uid'] }}
{%- endmacro %}
