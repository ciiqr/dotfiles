{% import "macros/primary.sls" as primary with context %}

{% macro extension(name) -%}
{%- set code = salt['cmd.which_bin'](['code-oss', 'code', 'vscode']) -%}
{{ sls }}.vscode.ext.{{ name }}:
  cmd.run:
    - name: {{ code }} --install-extension '{{ name }}'
    - runas: {{ primary.user() }}
    - unless: {{ code }} --list-extensions 2>/dev/null | grep -qi '^{{ name }}$'
  {%- if caller is defined -%}
    {{ caller() }}
  {%- endif -%}
{%- endmacro %}

{% macro all_extensions() %}
{%- set _caller = caller() -%}
{%- load_yaml as extensions %}{{ _caller }}{% endload -%}
{%- for name in extensions %}
{{ extension(name) }}
{% endfor -%}
{% endmacro %}
