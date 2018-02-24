{% macro optional_high_states() -%}
  {%- if salt['roots.state_exists'](slspath=slspath, *varargs) -%}
    {{ caller() }}
    {%- for name in varargs %}
      {%- if salt['roots.state_exists'](name, slspath=slspath) %}
    - {{ name }}
      {%- endif -%}
    {% endfor %}
  {%- endif -%}
{%- endmacro %}

{% macro optional_include() -%}
  {%- if salt['roots.state_exists'](slspath=slspath, *varargs) -%}
    include:
    {%- for name in varargs %}
      {%- if salt['roots.state_exists'](name, slspath=slspath) %}
      - {{ name }}
      {%- endif -%}
    {% endfor %}
  {%- endif -%}
{%- endmacro %}
