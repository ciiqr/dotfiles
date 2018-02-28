{% macro option(data, name) %}
{%- if name in data -%}
- {{ name }}: {{ data[name] | yaml }}
{%- endif -%}
{% endmacro %}
