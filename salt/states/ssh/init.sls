{% import "macros/optional.sls" as optional with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% from "macros/common.sls" import role_includes, platform with context %}

{% call optional.include() %}
  {{ role_includes() }}
{%- endcall %}

{% if not platform == 'windows' %}
{{ sls }}.config.perms:
  file.directory:
    - name: {{ grains['configDir'] }}/salt/states/{{ slspath }}/home/.ssh
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - dir_mode: 700
    - file_mode: 600
    - recurse:
      - user
      - group
      - mode
{{ sls }}.perms:
  file.directory:
    - name: {{ grains['privateConfigDir'] }}/salt/states/private/{{ slspath }}/home/.ssh
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - dir_mode: 700
    - file_mode: 600
    - recurse:
      - user
      - group
      - mode
{% endif %}

{{ dotfiles.link_static() }}
