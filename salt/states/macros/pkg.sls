{% from "macros/common.sls" import option, os_family with context %}

# TODO: maybe it makes more sense to error out on missing package, but support setting to null to indicate to skip (maybe then we also don't need to dumb test.show_notification)
{% macro installed(name) -%}
{%- set package = pillar.get('packages', {}).get(name) -%}
{{ sls }}.pkg.{{ name }}:
{%- if package is not none %}
  pkg.installed:
    {%- if package is string %}
    - name: {{ package }}
    {% else %}
    - pkgs: {{ package | yaml }}
    {% endif %}
    - install_recommends: False
  {%- if caller is defined -%}
    {{ caller() }}
  {%- endif -%}
{%- else %}
  test.show_notification:
    - text: No {{ name }} package configured.
{% endif %}
{%- endmacro %}

{% macro repo(name) -%}
{%- set repo = pillar.get('repositories', {}).get(name) -%}
{%- if repo is not none %}
{{ sls }}.repo.{{ name }}:

  {%- if os_family == 'Debian' %}
  pkgrepo.managed:
    {%- if repo is string -%}
      {%- set repo = {'uri': repo} -%}
    {%- endif -%}
    {% set type = repo.get('type', 'deb') %}
    {% set options = repo.get('options', '') %}
    {% set uri = repo['uri'] %}
    {% set dist = repo.get('dist', grains['lsb_distrib_codename']) %}
    {% set comps = repo.get('comps', 'main') %}

    - name: {{ type }} {{ options }} {{ uri }} {{ dist }} {{ comps }}
    - file: /etc/apt/sources.list.d/{{ name }}.list
    - comments: Managed by Salt
    {{ option(repo, 'keyserver') }}
    {{ option(repo, 'keyid') }}
    {{ option(repo, 'key_url') }}
    {%- if caller is defined -%}
    {{ caller() }}
    {%- endif -%}

  {%- else %}
  test.show_notification:
    - text: Not configured to configure repo's for {{ os_family }}
  {% endif %}

{%- endif -%}
{%- endmacro %}

{% macro all_installed() %}
{%- set _caller = caller() -%}
{%- load_yaml as packages %}{{ _caller }}{% endload -%}
{%- for name in packages %}
{{ installed(name) }}
{% endfor -%}
{% endmacro %}
