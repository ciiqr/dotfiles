{% import "macros/root.sls" as root with context %}
{% from "macros/common.sls" import platform with context %}

{% macro global(name, content) %}
{%- if platform in ['osx'] -%}

{{ sls }}.path.{{ name }}:
  file.managed:
    - name: /etc/paths.d/{{ name }}
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - makedirs: true
    - contents: {{ content }}

{%- else -%}

{{ sls }}.path.{{ name }}:
  file.managed:
    - name: /etc/profile.d/{{ name }}.sh
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - makedirs: true
    - contents: export PATH="{{ content }}:$PATH"

{% endif %}
{% endmacro %}
