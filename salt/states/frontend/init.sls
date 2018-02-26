{% from slspath + "/map.jinja" import frontend with context %}
{% from "macros/optional.sls" import optional_include with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}

{{ optional_include(
  '.ssh',
  'private.' ~ sls,
  '.' ~ grains['platform'],
  'private.' ~ sls ~ '.' ~ grains['platform']
) }}

{{ pkg.installed('baobab', frontend) }}

{{ dotfiles.link_static() }}
