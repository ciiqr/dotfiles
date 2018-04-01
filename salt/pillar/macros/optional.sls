{% macro pillar_stacks() -%}
  {%- if 'roots.pillar_exists' not in __salt__ -%}
    {%- do __salt__['log.debug']('roots.pillar_exists module does not exist') -%}
  {%- else -%}
    {%- set _caller = caller() -%}
    {%- load_yaml as includes %}{{ _caller }}{% endload -%}
    {%- if __salt__['roots.pillar_exists'](slspath=slspath, *includes) -%}
      {%- for name in includes %}
        {%- if __salt__['roots.pillar_exists'](name, slspath=slspath) %}
{{ name }}.sls
        {%- endif -%}
      {% endfor %}
    {%- endif -%}
  {%- endif -%}
{%- endmacro %}
