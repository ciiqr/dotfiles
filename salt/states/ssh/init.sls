{% import "macros/optional.sls" as optional with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% from "macros/common.sls" import platform with context %}

{% call optional.include() %}
  - private.{{ sls }}
  - .{{ platform }}
  - private.{{ sls }}.{{ platform }}
{%- endcall %}

{% if not platform == 'windows' %}
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
