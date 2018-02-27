{% from slspath + "/map.jinja" import frontend with context %}
{% import "macros/optional.sls" as optional with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}

{% call optional.include() %}
  - .ssh
  - .quick-launch
  - sublime
  - private.{{ sls }}
  - .{{ grains['platform'] }}
  - private.{{ sls }}.{{ grains['platform'] }}
{%- endcall %}

{{ dotfiles.link_static() }}

{{ pkg.installed('baobab', frontend) }}
{{ pkg.installed('sublime', frontend) }}
