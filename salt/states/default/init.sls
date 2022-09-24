{% import "macros/optional.sls" as optional with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/root.sls" as root with context %}
{% from "macros/common.sls" import role_includes, platform, os with context %}

{% set default = salt['pillar.get']('default', {}) %}

# Hostname
{{ sls }}.hostname:
  hostname.system:
    - name: {{ default.get('hostname', grains['id']) }}

# TODO: merge this into above?
{{ sls }}.hostname.preserve:
  file.managed:
    - name: /etc/hostname
    - contents: {{ default.get('hostname', grains['id']) }}
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644

# Timezone
{{ sls }}.timezone:
  timezone.system:
    - name: America/Toronto
    - utc: true
