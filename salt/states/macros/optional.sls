{% macro optional_high_states() -%}
  {%- if salt['rootscheck.state_exists'](slspath=slspath, *varargs) -%}
    {{ caller() }}
    {%- for name in varargs %}
      {%- if salt['rootscheck.state_exists'](name, slspath=slspath) %}
    - {{ name }}
      {%- endif -%}
    {% endfor %}
  {%- endif -%}
{%- endmacro %}

{% macro optional_include() -%}
  {%- if salt['rootscheck.state_exists'](slspath=slspath, *varargs) -%}
    include:
    {%- for name in varargs %}
      {%- if salt['rootscheck.state_exists'](name, slspath=slspath) %}
      - {{ name }}
      {%- endif -%}
    {% endfor %}
  {%- endif -%}
{%- endmacro %}
