{% import "macros/primary.sls" as primary with context %}

{% set external = salt['pillar.get']('development:external', {}) %}

{% if 'git.checkout' in salt %}

{% for key in external %}
{%- set repo = external[key] -%}
{{ sls }}.{{ key }}:
  git.latest:
    - name: {{ repo.get('remote') }}
    - target: {{ primary.home() }}/external/{{ repo.get('folder', key) }}
    - user: {{ primary.user() }}
    - rev: {{ repo.get('rev') }}
    - force_reset: true
{% endfor %}

{% endif %}
