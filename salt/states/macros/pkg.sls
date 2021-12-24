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

{% macro all_installed() %}
{%- set _caller = caller() -%}
{%- load_yaml as packages %}{{ _caller }}{% endload -%}
{%- for name in packages %}
{{ installed(name) }}
{% endfor -%}
{% endmacro %}
