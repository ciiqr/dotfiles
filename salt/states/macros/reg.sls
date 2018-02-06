{% macro dword(path, key, value) -%}
{{ sls }}.{{ key }}:
  reg.present:
    - name: {{ path }}
    - vname: {{ key }}
    - vtype: REG_DWORD
    - vdata: {{ value }}
{%- endmacro %}
