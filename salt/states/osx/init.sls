{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}

{% call optional.include() %}
  - .defaults
  - .power
  - .locate
  - private.{{ sls }}]
{%- endcall %}

{{ dotfiles.link_static() }}
