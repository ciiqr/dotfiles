{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% from "macros/common.sls" import role_includes with context %}

{% set base = pillar.get('base', {}) %}
{% set git = pillar.get('git', {}) %}

{% call optional.include() %}
  {{ role_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}

{% if 'git.config_set' in salt %}

{% set config = git.config %}
{% for name in config %}
{{ sls }}.config.{{ name }}:
  git.config_set:
    - name: {{ name }}
    - value: {{ config[name] | yaml }}
    - user: {{ primary.user() }}
    - global: true

{% endfor %}

{% endif %}
