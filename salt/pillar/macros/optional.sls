{% macro optional_pillar_stacks() -%}
  {%- if __salt__['rootscheck.pillar_exists'](slspath=slspath, *varargs) -%}
    {%- for name in varargs %}
      {%- if __salt__['rootscheck.pillar_exists'](name, slspath=slspath) -%}
        {{ name }}.sls
      {%- endif -%}
    {% endfor %}
  {%- endif -%}
{%- endmacro %}
