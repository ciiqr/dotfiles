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
    # TODO: this breaks when the lts version changes, switch to use the latest lts version explicitly
    # OR nvm install lts/* --reinstall-packages-from=lts/*
    - name: . "${HOME}/.nvm/nvm.sh" && nvm alias default 'lts/*'
    - runas: {{ primary.user() }}
    - onchanges:
      - git: {{ sls }}.clone.nvm

# TODO: at least on osx, link node
# sudo ln -s "$(which node)" /usr/local/bin/node


{% endif -%}
