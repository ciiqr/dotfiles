{% import "macros/optional.sls" as optional with context %}
{% from "macros/common.sls" import platform with context %}

{% call optional.include() %}
  - private.{{ sls }}
  - .{{ platform }}
  - private.{{ sls }}.{{ platform }}
{%- endcall %}
