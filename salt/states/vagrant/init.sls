{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% from "macros/common.sls" import id_includes with context %}

{% call optional.include() %}
  {{ id_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}

exclude:
  - sls: default

{{ sls }}.primary-user:
  user.present:
    - name: {{ primary.user() }}
    - fullname: 'Vagrant'
    - shell: /bin/zsh
    - home: {{ primary.home() }}
    - remove_groups: False
