{% import "macros/optional.sls" as optional with context %}

{% call optional.include() %}
  - private.{{ sls }}
  - .{{ grains['platform'] }}
  - private.{{ sls }}.{{ grains['platform'] }}
{%- endcall %}
