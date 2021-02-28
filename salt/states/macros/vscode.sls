{% import "macros/primary.sls" as primary with context %}
{% from "macros/common.sls" import platform with context %}

# TODO: need to switch this to a proper module (something in windows broke this recently)
{% macro extension(name) -%}
{%- set code = salt['cmd.which_bin'](['code-oss', 'code', 'vscode']) -%}
{{ sls }}.vscode.ext.{{ name }}:
  cmd.run:
    {%- if platform in ['windows'] %}
    - name: {{ ("& '" ~ code ~ "' --install-extension '" ~ name ~ "'") | yaml }}
    - shell: powershell
    {%- else %}
    - name: {{ code }} --install-extension '{{ name }}'
    {%- endif %}
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
