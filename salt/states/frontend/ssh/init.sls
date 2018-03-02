{% import "macros/primary.sls" as primary with context %}
{% from "macros/common.sls" import platform with context %}

{% if not platform == 'windows' %}
{{ sls }}.perms:
  file.directory:
    - name: {{ grains['privateConfigDir'] }}/salt/states/private/frontend/home/.ssh
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - dir_mode: 700
    - file_mode: 600
    - recurse:
      - user
      - group
      - mode
{% endif %}
