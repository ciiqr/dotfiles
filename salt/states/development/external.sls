{% import "macros/primary.sls" as primary with context %}

{% set external = salt['pillar.get']('development:external', {}) %}

{% if 'git.checkout' in salt %}

{% for key in external %}
{%- set repo = external[key] -%}
{{ sls }}.{{ key }}:
  git.latest:
    - name: {{ repo.get('remote') }}
    - target: {{ primary.home() }}/External/{{ repo.get('folder', key) }}
    - user: {{ primary.user() }}
    - rev: {{ repo.get('rev') }}
    - force_reset: true
    - force_fetch: true

{{ sls }}.{{ key }}.sublime-project:
  file.managed:
    - name: {{ primary.home() }}/External/.sublime/external-{{ repo.get('folder', key) | replace('/', '-') }}.sublime-project
    - source: salt://{{ slspath }}/files/external.sublime-project
    - makedirs: true
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - mode: 600
    - template: jinja
    - context:
        folder: {{ repo.get('folder', key) }}

{% endfor %}

{% endif %}
