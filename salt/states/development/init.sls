{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}

{% call optional.include() %}
  - .git
  - private.{{ sls }}
  - .{{ grains['platform'] }}
  - private.{{ sls }}.{{ grains['platform'] }}
{%- endcall %}

{{ dotfiles.link_static() }}
