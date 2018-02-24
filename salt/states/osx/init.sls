{% from "macros/optional.sls" import optional_include with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}

{{ optional_include(
  '.defaults',
  '.power',
  '.locate',
  'private.' ~ sls
) }}

{{ dotfiles.link_static() }}
