{% import "macros/dotfiles.sls" as dotfiles with context %}

{% if not grains['platform'] in ['windows', 'osx'] %}

{{ dotfiles.link_static() }}

{% endif %}
