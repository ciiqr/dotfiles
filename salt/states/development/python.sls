{% import "macros/primary.sls" as primary with context %}
{% from "macros/common.sls" import platform with context %}
{% set current_path = salt['environ.get']('PATH', '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin') %}

# NOTE: General setup inspired by: https://jacobian.org/2019/nov/11/python-environment-2020/

# TODO: figure out windows?

{% if not platform in ['windows'] %}

# Python
{% if 'git.checkout' in salt %}

# TODO: install build deps (at least below): https://github.com/pyenv/pyenv/wiki#suggested-build-environment
# - ie. void: readline-devel, sqlite-devel
# TODO: poetry completions: https://python-poetry.org/docs/#enable-tab-completion-for-bash-fish-or-zsh
# TODO: as required (some may live as project (dev) deps, others may simply not be required)
# - bpython
# - setuptools?
# - virtualenv
# - pipenv
# TODO: make these upgrade if applicable?

{{ sls }}.clone.pyenv:
  git.latest:
    - name: https://github.com/pyenv/pyenv.git
    - target: {{ primary.home() }}/.pyenv
    - user: {{ primary.user() }}

{% endif %}

{{ sls }}.3.8.5:
  cmd.run:
    - name: pyenv install -ks 3.8.5
    - runas: {{ primary.user() }}
    - shell: /bin/bash
    - env:
      - BASH_ENV: /etc/profile
    - unless: pyenv prefix 3.8.5

{{ sls }}.global:
  cmd.run:
    - name: pyenv global 3.8.5
    - runas: {{ primary.user() }}
    - shell: /bin/bash
    - env:
      - BASH_ENV: /etc/profile
    - unless: pyenv global | grep -q '^3.8.5$'

{{ sls }}.pipx:
  cmd.run:
    - name: pip install pipx
    - runas: {{ primary.user() }}
    - shell: /bin/bash
    - env:
      - BASH_ENV: /etc/profile
      - PATH: {{ [primary.home() ~ '/.pyenv/shims', current_path]|join(':') }}
    - unless: pip show pipx

{{ sls }}.poetry:
  cmd.run:
    - name: pipx install poetry
    - runas: {{ primary.user() }}
    - shell: /bin/bash
    - env:
      - BASH_ENV: /etc/profile
      - PATH: {{ [primary.home() ~ '/.pyenv/shims', current_path]|join(':') }}
    - unless: pipx runpip poetry list
# NOTE: optional dependencies of poetry could be installed with: pipx inject poetry pandas

{% endif -%}
