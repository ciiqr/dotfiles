{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}

{% call optional.include() %}
  - .programs
  - .tweaks
  - private.{{ sls }}
{%- endcall %}

{{ dotfiles.link_static() }}
