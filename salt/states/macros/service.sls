{% macro running(name, _pillar) -%}
{%- set service = _pillar.get('services', {}).get(name) -%}
{{ sls }}.service.{{ name }}:
{%- if service is not none -%}
  {%- if pillar.get('installer', False) %}
  service.enabled:
  {%- else %}
  service.running:
    - enable: True
  {%- endif %}
    - name: {{ service }}
  {%- if caller is defined -%}
    {{ caller() }}
  {%- endif -%}
{%- else %}
  test.show_notification:
    - text: No {{ name }} service configured.
{% endif %}
{%- endmacro %}
