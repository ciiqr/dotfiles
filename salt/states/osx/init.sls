{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% from "macros/common.sls" import platform_includes with context %}
{% import "macros/pkg.sls" as pkg with context %}

{% call optional.include() %}
  - .defaults
  - .power
  - .locate
  - .hidden
  - .terminal
  - .default-programs
  {{ platform_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}

{% call pkg.all_installed() %}
  - macdown
{% endcall %}
