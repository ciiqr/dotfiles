{% from "macros/optional.sls" import optional_include with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}

{{ optional_include(
  '.git',
  'private.' ~ sls,
  '.' ~ grains['platform'],
  'private.' ~ sls ~ '.' ~ grains['platform']
) }}

{{ dotfiles.link_static() }}
