{% import "macros/primary.sls" as primary with context %}
{% from slspath + "/map.jinja" import development with context %}

{% if 'git.config_set' in salt %}

{% set config = development.git.config %}
{% for name in config %}
{{ sls }}.config.{{ name }}:
  git.config_set:
    - name: {{ name }}
    - value: {{ config[name] | yaml }}
    - user: {{ primary.user() }}
    - global: true

{% endfor %}

{% endif %}
