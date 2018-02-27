{% from slspath + "/map.jinja" import development with context %}

{% set config = development.git.config %}
{% for name in config %}
{{ sls }}.config.{{ name }}:
  git.config_set:
    - name: {{ name }}
    - value: {{ config[name] }}
    - user: {{ grains['primaryUser'] }}
    - global: true

{% endfor %}
