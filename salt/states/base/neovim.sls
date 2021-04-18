{% from "macros/common.sls" import platform with context %}
{% import "macros/primary.sls" as primary with context %}

{{ sls }}.~/.local/share/nvim/site/autoload/plug.vim:
  file.managed:
    - name: {{ primary.home() }}/.local/share/nvim/site/autoload/plug.vim
    - source: https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    - makedirs: true
    - skip_verify: true # TODO: ugh external things
    - user: {{ primary.user() }}
    {% if not platform == 'windows' %}
    - group: {{ primary.group() }}
    - mode: 600
    {% endif %}

# TODO: hash nvim/init.vim and cache somewhere, then rebuild this if that hash changes. may be easier once we switch to ansible
# {{ sls }}.plugin-install:
#   cmd.run:
#     - name: nvim --headless +PlugInstall +qall
#     - runas: {{ primary.user() }}
#     - onchanges:
#       - file: {{ sls }}.~/.local/share/nvim/site/autoload/plug.vim
