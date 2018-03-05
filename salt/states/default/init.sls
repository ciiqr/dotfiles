{% import "macros/optional.sls" as optional with context %}
{% from "macros/common.sls" import platform, os_family, os, id with context %}

{% call optional.include() %}
  - .default
  - private.{{ sls }}
  - .{{ platform }}
  - private.{{ sls }}.{{ platform }}
  - .{{ os_family }}
  - private.{{ sls }}.{{ os_family }}
  {% if os != os_family -%}
  - .{{ os }}
  - private.{{ sls }}.{{ os }}
  {%- endif %}
  - .{{ id }}
  - private.{{ sls }}.{{ id }}
{%- endcall %}
