{% macro high_states() -%}
  {%- if 'roots.pillar_exists' not in __salt__ -%}
    {%- do __salt__['log.warning']('roots.pillar_exists module does not exist') -%}
  {%- else -%}
    {%- if salt['roots.state_exists'](slspath=slspath, *varargs) -%}
      {{ caller() }}
      {%- for name in varargs %}
        {%- if salt['roots.state_exists'](name, slspath=slspath) %}
      - {{ name }}
        {%- endif -%}
      {% endfor %}
    {%- endif -%}
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
