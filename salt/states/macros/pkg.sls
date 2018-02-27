{% macro installed(name, _pillar) -%}
{%- set package = _pillar.get('packages', {}).get(name) -%}
{{ sls }}.{{ name }}:
{%- if package is not none %}
  pkg.installed:
    {%- if package is string %}
    - name: {{ package }}
    {% else %}
    - pkgs: {{ package | yaml }}
    {% endif %}
  {%- if caller is defined -%}
    {{ caller() }}
  {%- endif -%}
{%- else %}
  test.show_notification:
    - text: No {{ name }} package configured.
{% endif %}
{%- endmacro %}
