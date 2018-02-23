{% macro installed(package, _pillar) -%}
{{ sls }}.{{ package }}:
{%- if _pillar and _pillar.get(package) is not none %}
  pkg.installed:
    - name: {{ _pillar.get(package) }}
  {%- if caller is defined -%}
    {{ caller() }}
  {%- endif -%}
{%- else %}
  test.show_notification:
    - text: No {{ package }} package configured.
{% endif %}
{%- endmacro %}
