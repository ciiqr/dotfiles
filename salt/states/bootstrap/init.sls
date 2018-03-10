{% import "macros/optional.sls" as optional with context %}
{% from "macros/common.sls" import role_includes with context %}

{% call optional.include() %}
  {{ role_includes() }}
{%- endcall %}
