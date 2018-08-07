{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}

include:
  - .karabiner
  - .sublime
  - .chunkwm

{{ dotfiles.link_static() }}
