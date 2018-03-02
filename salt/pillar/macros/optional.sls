{% macro pillar_stacks() -%}
  {%- set _caller = caller() -%}
  {%- load_yaml as includes %}{{ _caller }}{% endload -%}
  {%- if __salt__['roots.pillar_exists'](slspath=slspath, *includes) -%}
    {%- for name in includes %}
      {%- if __salt__['roots.pillar_exists'](name, slspath=slspath) %}
{{ name }}.sls
      {%- endif -%}
    {% endfor %}
  {%- endif -%}
{%- endmacro %}
