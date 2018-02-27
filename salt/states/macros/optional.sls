{% macro high_states() -%}
  {%- if salt['roots.state_exists'](slspath=slspath, *varargs) -%}
    {{ caller() }}
    {%- for name in varargs %}
      {%- if salt['roots.state_exists'](name, slspath=slspath) %}
    - {{ name }}
      {%- endif -%}
    {% endfor %}
  {%- endif -%}
{%- endmacro %}

{% macro include() -%}
  {%- set _caller = caller() -%}
  {%- load_yaml as includes %}{{ _caller }}{% endload -%}
  {%- if salt['roots.state_exists'](slspath=slspath, *includes) -%}
include:
    {%- for name in includes %}
      {%- if salt['roots.state_exists'](name, slspath=slspath) %}
  - {{ name }}
      {%- endif -%}
    {% endfor %}
  {%- endif -%}
{%- endmacro %}
