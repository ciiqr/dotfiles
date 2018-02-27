{% macro pillar_stacks() -%}
  {%- if __salt__['roots.pillar_exists'](slspath=slspath, *varargs) -%}
    {%- for name in varargs %}
      {%- if __salt__['roots.pillar_exists'](name, slspath=slspath) %}
{{ name }}.sls
      {%- endif -%}
    {% endfor %}
  {%- endif -%}
{%- endmacro %}
