{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% from "macros/common.sls" import role_includes with context %}

{% call optional.include() %}
  {{ role_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}
