{% import "macros/primary.sls" as primary with context %}
{% from "macros/common.sls" import platform with context %}

{% if not platform in ['windows'] %}

{% if 'git.checkout' in salt %}

{{ sls }}.clone.nvm:
  git.latest:
    - name: https://github.com/nvm-sh/nvm.git
    - target: {{ primary.home() }}/.nvm
    - user: {{ primary.user() }}

{% endif %}

{{ sls }}.install.lts:
  cmd.run:
    - name: . "${HOME}/.nvm/nvm.sh" && nvm install --lts
    - runas: {{ primary.user() }}
    - onchanges:
      - git: {{ sls }}.clone.nvm

{{ sls }}.default.lts:
  cmd.run:
    - name: . "${HOME}/.nvm/nvm.sh" && nvm alias default 'lts/*'
    - runas: {{ primary.user() }}
    - onchanges:
      - git: {{ sls }}.clone.nvm

{% endif -%}
