{% import "macros/dotfiles.sls" as dotfiles with context %}
{% from "macros/common.sls" import platform with context %}

{% if not platform in ['windows', 'osx'] %}

{{ dotfiles.link_static() }}

{% endif %}
