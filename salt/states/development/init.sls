{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/root.sls" as root with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/path.sls" as path with context %}
{% from "macros/common.sls" import role_includes, platform, roles with context %}

{% set base = pillar.get('base', {}) %}
{% set development = pillar.get('development', {}) %}

{% call optional.include() %}
  - .git
  - .external
  {{ role_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}

{% call pkg.all_installed() %}
  # General
  - build-essential
  - git
  - cloc
  - pkg-config
  - sloccount
  - pssh

  # Shell
  - shellcheck

  # Swift
  # TODO: re-enable - swift
  - swift-perfect-dependencies

  # Python
  - python
  - bpython
  - pip
  - python-dev
  - python-setuptools
  # TODO: maybe move these to pip...
  - virtualenv

  # Coffeescript
  # install coffeescript

  # Sass
  # install sassc

  # lmdb
  # install liblmdb0 lmdb-doc lmdb-utils

  # Scala
  # install scala

  # Nim
  - nim

  # Mono
  - mono
  - mono-libraries

  # C++
  - cpp

  # Valgrind
  - valgrind

  # Strace
  - strace

  # Ubuntu installer
  - installer-ubuntu

  # Vagrant
  - vagrant
  - virtualbox
  - vagrant-nfs

  # Docker
  - docker

  # Github cli
  - hub

  # gcloud
  - google-cloud-sdk

  # flutter
  - flutter
{% endcall %}

# Python
{% if not platform in ['windows'] %}
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


{{ sls }}.~/.vagrant.d/vagrantfile:
  file.managed:
    - name: {{ primary.home() }}/.vagrant.d/vagrantfile
    - source: salt://{{ slspath }}/files/vagrantfile
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
{% if not platform in ['windows'] %}
    - mode: 600
{% endif %}
    - makedirs: true
    - template: jinja

{% set hashicorp_platform = development.hashicorp.platform_map.get(platform) %}
{% set hashicorp_arch = development.hashicorp.arch_map.get(grains['cpuarch']) %}
{% if hashicorp_platform is not none and hashicorp_arch is not none %}
# Terraform
{% set terraform_hash = development.terraform.hash_map.get(platform) %}
{{ sls }}.src.terraform:
  archive.extracted:
    - name: {{ base.src_path }}/terraform-{{ development.terraform.version }}
    - source: https://releases.hashicorp.com/terraform/{{ development.terraform.version }}/terraform_{{ development.terraform.version }}_{{ hashicorp_platform }}_{{ hashicorp_arch }}.zip
    - source_hash: {{ terraform_hash }}
    - enforce_toplevel: false
    - if_missing: {{ base.src_path }}/terraform-{{ development.terraform.version }}

# Add terraform to PATH
{{ path.global('terraform', base.src_path ~ '/terraform-' ~ development.terraform.version) }}


# Packer
{% set packer_hash = development.packer.hash_map.get(platform) %}
{{ sls }}.src.packer:
  archive.extracted:
    - name: {{ base.src_path }}/packer-{{ development.packer.version }}
    - source: https://releases.hashicorp.com/packer/{{ development.packer.version }}/packer_{{ development.packer.version }}_{{ hashicorp_platform }}_{{ hashicorp_arch }}.zip
    - source_hash: {{ packer_hash }}
    - enforce_toplevel: false
    - if_missing: {{ base.src_path }}/packer-{{ development.packer.version }}

# Add packer to PATH
{{ path.global('packer', base.src_path ~ '/packer-' ~ development.packer.version) }}

{% endif %}

{% if not platform in ['windows', 'osx'] %}

# Godot
{{ sls }}.src.godot:
  archive.extracted:
    - name: {{ base.src_path }}/godot-{{ development.godot.version }}
    - source: https://downloads.tuxfamily.org/godotengine/{{ development.godot.version }}/mono/Godot_v{{ development.godot.version }}-stable_mono_x11_64.zip
    - skip_verify: true
    - if_missing: {{ base.src_path }}/godot-{{ development.godot.version }}

{{ sls }}.desktop-file.godot:
  file.managed:
    - name: /usr/share/applications/godot.desktop
    - source: salt://{{ slspath }}/files/godot.desktop
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - template: jinja
    - context:
        version: {{ development.godot.version }}

# TODO: Install swift via deb
# https://swift.org/builds/swift-4.0.3-release/ubuntu1610/swift-4.0.3-RELEASE/swift-4.0.3-RELEASE-ubuntu16.10.tar.gz
# https://swift.org/download/#using-downloads

{% endif %}

# TODO: decide if I want these here or in frontend...
{% if 'frontend' in roles %}

{% call pkg.all_installed() %}
  - meld
  - virtualbox-ui
  - qtcreator
  - monodevelop
  - kcachegrind
  - xephyr
{% endcall %}

{% endif %}
