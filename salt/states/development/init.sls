{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/root.sls" as root with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/vscode.sls" as vscode with context %}
{% import "macros/path.sls" as path with context %}
{% from "macros/common.sls" import role_includes, platform, roles with context %}
{% import "macros/npm.sls" as npm with context %}

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
  - git
  - gnupg
  - cloc
  - pkg-config
  - sloccount
  - pssh
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
  - virtualbox
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
  - minikube
  - telepresence
  # ansible
  - ansible
  # flutter
  - flutter
  # tls
  - gnutls # ie. certtool
  # Android
  - kotlin
  - android-studio
  - android-sdk
  # rust
  - rust
{% endcall %}

{% if not platform in ['windows', 'osx'] %}

{{ sls }}.group.docker:
  group.present:
    - name: docker
    - system: true
    - members:
      - {{ primary.user() }}

{% endif %}

{% if not platform in ['windows'] %}

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


# TODO: not all compatible with codespaces...
# # packages
# - monokai.theme-monokai-pro-vscode -> adamcaviness.theme-monokai-dark-soda
# settings
# - "workbench.colorTheme": "Monokai Dark Soda",
# - "workbench.iconTheme": "vs-seti",

# vscode
{% call vscode.all_extensions() %}
  # theme
  - monokai.theme-monokai-pro-vscode
  # workbench
  - RoscoP.ActiveFileInStatusBar
  # editor
  - cardinal90.multi-cursor-case-preserve
  - editorconfig.editorconfig
  - naumovs.color-highlight
  - rafamel.subtle-brackets
  # commands
  - wmaurer.change-case
  - eriklynd.json-tools
  - tyriar.sort-lines
  - sleistner.vscode-fileutils
  - v4run.transpose
  # syntaxes
  - korekontrol.saltstack
  - redhat.vscode-yaml
  - fwcd.kotlin
  - matklad.rust-analyzer
  - serayuzgur.crates
  - breadnaught.vscode-ignore
  # static analysis
  - SonarSource.sonarlint-vscode
{% endcall %}

# TODO: this is really more dependent on frontend, but still needs nvm...
{{ npm.install('clipboard-cli') }}

{% endif %}
