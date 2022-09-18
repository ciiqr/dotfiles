{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/root.sls" as root with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/path.sls" as path with context %}
{% from "macros/common.sls" import role_includes, platform, roles with context %}
{% import "macros/npm.sls" as npm with context %}

{% set base = pillar.get('base', {}) %}
{% set development = pillar.get('development', {}) %}

{% call optional.include() %}
  - .python
  {{ role_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}

{% call pkg.all_installed() %}
  # General
  - git
  - gnupg
  - cloc
  - pkg-config
  - pup
  - wrk
  - fswatch
  - vscode
  # Shell
  - shellcheck
  - checkbashisms
  - shfmt
  # Custom os installers
  - installer-arch
  # VMs
  - virtualbox
  - vagrant
  # Docker
  - docker
  - docker-machine
  # Github cli
  - hub
  # awscli
  - awscli
  # kubernetes
  - kubectl
  - kubectx
  - helm
  - minikube
  - telepresence
  # ansible
  - ansible
  # tls
  - gnutls # ie. certtool
  # Android
  - kotlin
  - android-studio
  - android-sdk
  # rust
  - rust
{% endcall %}

# TODO: rustup toolchain install stable

{% if not platform in ['windows', 'osx'] %}

{{ sls }}.group.docker:
  group.present:
    - name: docker
    - system: true
    - members:
      - {{ primary.user() }}

{% endif %}

{% if platform in ['linux'] %}

# Virtualbox
{{ sls }}.virtualbox.machinefolder:
  cmd.run:
    - name: VBoxManage setproperty machinefolder '{{ primary.home() }}/.vms'
    - runas: {{ primary.user() }}
    - unless: "[ $(VBoxManage list systemproperties | grep 'Default machine folder:' | awk -F ':[ \t]+' '{print $2}') == '{{ primary.home() }}/.vms' ]"

{% endif %}

# TODO: decide if I want these here or in frontend...
{% if 'frontend' in roles %}

{% call pkg.all_installed() %}
  - meld
  - virtualbox-ui
  - qtcreator
  - kcachegrind
  - xephyr
{% endcall %}

{% endif %}
