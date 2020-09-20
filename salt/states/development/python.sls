{% import "macros/primary.sls" as primary with context %}
{% from "macros/common.sls" import platform with context %}

# NOTE: General setup inspired by: https://jacobian.org/2019/nov/11/python-environment-2020/

# TODO: figure out windows?

{% if not platform in ['windows'] %}

# Python
{% if 'git.checkout' in salt %}

# TODO: install build deps (at least below): https://github.com/pyenv/pyenv/wiki#suggested-build-environment
# TODO: - ie. void: readline-devel, sqlite-devel

{{ sls }}.clone.pyenv:
  git.latest:
    - name: https://github.com/pyenv/pyenv.git
    - target: {{ primary.home() }}/.pyenv
    - user: {{ primary.user() }}

{% endif %}

# TODO: figure out a cleaner way to have pyenv shell setup properly for cmd.run's below (ie. simply source ~/.shared_profile, though that causes issues because virtualenv-init doesn't want to work at that point)

{{ sls }}.python.3.8.5:
  cmd.run:
    - name: export PYENV_ROOT="$HOME/.pyenv";export PATH="$PYENV_ROOT/bin:$PATH";eval "$(pyenv init -)"; pyenv install 3.8.5
    - runas: {{ primary.user() }}
    - shell: /bin/bash
    - unless: export PYENV_ROOT="$HOME/.pyenv";export PATH="$PYENV_ROOT/bin:$PATH";eval "$(pyenv init -)"; pyenv prefix 3.8.5

{{ sls }}.python.global:
  cmd.run:
    - name: export PYENV_ROOT="$HOME/.pyenv";export PATH="$PYENV_ROOT/bin:$PATH";eval "$(pyenv init -)"; pyenv global 3.8.5
    - runas: {{ primary.user() }}
    - shell: /bin/bash
    - unless: export PYENV_ROOT="$HOME/.pyenv";export PATH="$PYENV_ROOT/bin:$PATH";eval "$(pyenv init -)"; pyenv global | grep -q '^3.8.5$'

{{ sls }}.python.pipx:
  cmd.run:
    - name: export PYENV_ROOT="$HOME/.pyenv";export PATH="$PYENV_ROOT/bin:$PATH";eval "$(pyenv init -)"; pip install pipx
    - runas: {{ primary.user() }}
    - shell: /bin/bash
    - unless: export PYENV_ROOT="$HOME/.pyenv";export PATH="$PYENV_ROOT/bin:$PATH";eval "$(pyenv init -)"; pip show pipx

{{ sls }}.python.poetry:
  cmd.run:
    - name: export PYENV_ROOT="$HOME/.pyenv";export PATH="$PYENV_ROOT/bin:$PATH";eval "$(pyenv init -)"; pipx install poetry
    - runas: {{ primary.user() }}
    - shell: /bin/bash
    - unless: export PYENV_ROOT="$HOME/.pyenv";export PATH="$PYENV_ROOT/bin:$PATH";eval "$(pyenv init -)"; pipx runpip poetry list
# NOTE: optional dependencies of poetry could be installed with: pipx inject poetry pandas

# TODO: poetry completions: https://python-poetry.org/docs/#enable-tab-completion-for-bash-fish-or-zsh

# TODO: switch to installing python packages with pipx
# Python
# - bpython
# - pip
# - python-dev
# - python-setuptools
# # TODO: maybe move these to pip...
# - virtualenv
# - pipenv

  {% set pips = ['pip2', 'pip3'] %}
  {% for pip in pips -%}
    {%- set pip_bin = salt['cmd.which'](pip) -%}
    {%- if pip_bin is not none %}

# # TODO: pip module doesn't seem to support --user option...
# {{ sls }}.{{ pip }}.pip:
#   pip.installed:
#     - bin_env: {{ pip_bin }}
#     - name: pip
#     - upgrade: true

# {{ sls }}.{{ pip }}.setuptools:
#   pip.installed:
#     - bin_env: {{ pip_bin }}
#     - name: setuptools
#     - upgrade: true

# {{ sls }}.{{ pip }}.pipenv:
#   pip.installed:
#     - bin_env: {{ pip_bin }}
#     - name: pipenv
#     - upgrade: true

# # update
# {{ sls }}.{{ pip }}.uptodate:
#   pip.uptodate:
#     - bin_env: {{ pip_bin }}

    {% endif -%}
  {%- endfor %}
{% endif -%}
