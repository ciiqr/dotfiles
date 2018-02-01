{% macro optional_pillar_stacks() -%}
  {%- if __salt__['rootscheck.any_pillar_exists'](*varargs) -%}
    {%- for name in varargs %}
      {%- if __salt__['rootscheck.pillar_exists'](name) -%}
        {{ name }}.sls
      {%- endif -%}
    {% endfor %}
  {%- endif -%}
{%- endmacro %}
