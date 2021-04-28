{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/root.sls" as root with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/vscode.sls" as vscode with context %}
{% import "macros/path.sls" as path with context %}
{% from "macros/common.sls" import role_includes, platform, roles with context %}

{% set base = pillar.get('base', {}) %}
{% set development = pillar.get('development', {}) %}

{% call optional.include() %}
  - .external
  - .python
  - .nvm
  {{ role_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}

{% call pkg.all_installed() %}
  # General
  - build-essential
  - git
  - gnupg
  - cloc
  - pkg-config
  - sloccount
  - pssh
  - pup
  - wrk
  - fswatch

  # Shell
  - shellcheck
  - checkbashisms

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

  # Golang
  - go

  # Custom os installers
  - installer-ubuntu
  - installer-void

  # Vagrant
  - vagrant
  - virtualbox
  - vagrant-nfs

  # Docker
  - docker
  - docker-machine
  - podman

  # Github cli
  - hub

  # gcloud
  - google-cloud-sdk

  # awscli
  - awscli

  # kubernetes
  - kubectl
  - kubectx
  - helm
  - k9s
  - minikube
  - telepresence

  # ansible
  - ansible

  # flutter
  - flutter
  - vscode

  # tls
  - gnutls # ie. certtool
{% endcall %}

{% set hashicorp_platform = development.hashicorp.platform_map.get(platform) %}
{% if hashicorp_platform is not none %}
# Terraform
{% set terraform_hash = development.terraform.hash_map.get(platform) %}
{{ sls }}.src.terraform:
  archive.extracted:
    - name: {{ base.src_path }}/terraform-{{ development.terraform.version }}
    - source: https://releases.hashicorp.com/terraform/{{ development.terraform.version }}/terraform_{{ development.terraform.version }}_{{ hashicorp_platform }}_{{ grains['architecture'] }}.zip
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
    - source: https://releases.hashicorp.com/packer/{{ development.packer.version }}/packer_{{ development.packer.version }}_{{ hashicorp_platform }}_{{ grains['architecture'] }}.zip
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

{{ sls }}.group.docker:
  group.present:
    - name: docker
    - system: true
    - members:
      - {{ primary.user() }}

# kubectx
{% set kubectx_version = '0.7.0' %}
{{ sls }}.src.kubectx:
  archive.extracted:
    # NOTE: be careful when updating, as right now there is a top level directory in the zip (kubectx-0.7.0) but often this isn't the case with zips
    - name: {{ base.src_path }}
    - source: https://github.com/ahmetb/kubectx/archive/v{{ kubectx_version }}.zip
    - skip_verify: true
    - enforce_toplevel: false
    - if_missing: {{ base.src_path }}/kubectx-{{ kubectx_version }}

{{ sls }}.bin.kubectx:
  file.managed:
    - name: {{ base.src_path }}/kubectx-{{ kubectx_version }}/kubectx
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 755
    - replace: false

{{ sls }}.link.kubectx:
  file.symlink:
    - name: /usr/local/bin/kubectx
    - target: {{ base.src_path }}/kubectx-{{ kubectx_version }}/kubectx
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - makedirs: true

{{ sls }}.link.kubectx.zsh:
  file.symlink:
    - name: /usr/local/share/zsh/site-functions/_kubectx
    - target: {{ base.src_path }}/kubectx-{{ kubectx_version }}/completion/kubectx.zsh
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - makedirs: true

{{ sls }}.link.kubectx.bash:
  file.symlink:
    - name: /usr/local/share/bash-completion/completions/kubectx
    - target: {{ base.src_path }}/kubectx-{{ kubectx_version }}/completion/kubectx.bash
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - makedirs: true

{% endif %}

{% if not platform in ['windows'] %}

# kubectl krew
{{ sls }}.src.krew:
  archive.extracted:
    - name: {{ base.src_path }}/krew-{{ development.krew.version }}
    - source: https://github.com/kubernetes-sigs/krew/releases/download/v{{ development.krew.version }}/krew.tar.gz
    - skip_verify: true
    - enforce_toplevel: false
    - if_missing: {{ base.src_path }}/krew-{{ development.krew.version }}

{{ sls }}.install.krew:
  cmd.run:
    - name: {{ base.src_path }}/krew-{{ development.krew.version }}/krew-{{ grains['kernel'] | lower }}_{{ grains['architecture'] }} install krew
    - runas: {{ primary.user() }}
    - onchanges:
      - {{ sls }}.src.krew

{{ sls }}.krew.exec-as:
  cmd.run:
    - name: kubectl krew install exec-as
    - runas: {{ primary.user() }}
    - onchanges:
      - {{ sls }}.src.krew

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

# vscode
{% call vscode.all_extensions() %}
  - redhat.vscode-yaml
  # TODO: find alternatives
  # - wmaurer.change-case
  # - eriklynd.json-tools
  # - tyriar.sort-lines
  - sleistner.vscode-fileutils
  - editorconfig.editorconfig
{% endcall %}

{% endif %}
