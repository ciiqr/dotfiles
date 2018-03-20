{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% from "macros/common.sls" import id_includes with context %}

{% call optional.include() %}
  {{ id_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}

exclude:
  - sls: default
