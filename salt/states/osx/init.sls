{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% from "macros/common.sls" import platform_includes with context %}

{% call optional.include() %}
  - .defaults
  - .power
  - .locate
  {{ platform_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}
