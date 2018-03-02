{% import "macros/optional.sls" as optional with context %}
{% from "macros/common.sls" import platform, os_family, os with context %}

{% call optional.include() %}
  - private.{{ sls }}
  - .{{ platform }}
  - private.{{ sls }}.{{ platform }}
  - .{{ os_family }}
  - private.{{ sls }}.{{ os_family }}
  {% if os != os_family -%}
  - .{{ os }}
  - private.{{ sls }}.{{ os }}
  {%- endif %}
{%- endcall %}
