{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% from "macros/common.sls" import role_includes, platform, roles with context %}

{% set development = pillar.get('development', {}) %}

{% call optional.include() %}
  - .git
  - .external
  {{ role_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}

{% call pkg.all_installed(development) %}
  # General
  - build-essential
  - git
  - cloc
  - pkg-config
  - sloccount

  # Shell
  - shellcheck

  # Swift
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
{% endcall %}

# TODO: implement
# # update pip
# pip2 install --upgrade pip
# pip3 install --upgrade pip
# # update setuptools
# pip2 install --upgrade setuptools
# pip3 install --upgrade setuptools
# TODO: as the user? or just do global... though user may be safer, even for the above...
# pip2 install --user pipenv
# pip3 install --user pipenv

{% if not platform in ['windows', 'osx'] %}
# TODO: support dictionary based pkg pillars so we can set things like this up normally: elif package is mapping
# Vagrant
{{ sls }}.pkg.vagrant.ugh: # TODO: how best to handle version and grains (can I use jinja in pillar stack for this?)
  pkg.installed:
    - sources:
      - vagrant: https://releases.hashicorp.com/vagrant/{{ development.vagrant.version }}/vagrant_{{ development.vagrant.version }}_{{ grains['cpuarch'] }}.deb
{% endif %}

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

{% if not platform in ['windows', 'osx'] %}

# TODO: add support for platforms other than linux here
# Terraform
{{ sls }}.src.terraform:
  archive.extracted:
    - name: /usr/src/terraform-{{ development.terraform.version }}
    - source: https://releases.hashicorp.com/terraform/{{ development.terraform.version }}/terraform_{{ development.terraform.version }}_linux_{{ grains['osarch'] }}.zip
    - source_hash: {{ development.terraform.hash }}
    - enforce_toplevel: false
    - if_missing: /usr/src/terraform-{{ development.terraform.version }}

# Add terraform to PATH
{{ sls }}.path.terraform:
  file.managed:
    - name: /etc/profile.d/terraform.sh
    - user: root
    - group: root
    - mode: 644
    - contents: export PATH="/usr/src/terraform-{{ development.terraform.version }}:$PATH"

# Packer
{{ sls }}.src.packer:
  archive.extracted:
    - name: /usr/src/packer-{{ development.packer.version }}
    - source: https://releases.hashicorp.com/packer/{{ development.packer.version }}/packer_{{ development.packer.version }}_linux_{{ grains['osarch'] }}.zip
    - source_hash: {{ development.packer.hash }}
    - enforce_toplevel: false
    - if_missing: /usr/src/packer-{{ development.packer.version }}

# Add packer to PATH
{{ sls }}.path.packer:
  file.managed:
    - name: /etc/profile.d/packer.sh
    - user: root
    - group: root
    - mode: 644
    - contents: export PATH="/usr/src/packer-{{ development.packer.version }}:$PATH"

# TODO: godot
# {% set godot_version = '3.0.2' %}
# https://downloads.tuxfamily.org/godotengine/{{ godot_version }}/Godot_v{{ godot_version }}-stable_{{ grains['cpuarch'] | replace('_', '.') }}.zip
# sudo mkdir -p "/opt/godot"
# sudo unzip -o godot.zip -d "/opt/godot"
# rm "godot.zip"

# godot_dir="/opt/godot/Godot_v${godot_version}-${godot_release}_x11_64"
# if [[ ! -d "$godot_dir" ]]; then
#   godot_dir="/opt/godot"
# fi

# sudo tee "/usr/share/applications/godot.desktop" >/dev/null <<EOF

# [Desktop Entry]
# Name=Godot
# Comment=Godot game engine
# Exec=${godot_dir}/Godot_v$godot_version-${godot_release}_x11.64
# Terminal=false
# Type=Application
# StartupNotify=true
# EOF


# TODO: Install swift via deb
# https://swift.org/builds/swift-4.0.3-release/ubuntu1610/swift-4.0.3-RELEASE/swift-4.0.3-RELEASE-ubuntu16.10.tar.gz
# https://swift.org/download/#using-downloads

{% endif %}

# TODO: decide if I want these here or in frontend...
{% if 'frontend' in roles %}

{% call pkg.all_installed(development) %}
  - meld
  - virtualbox-ui
  - qtcreator
  - monodevelop
  - kcachegrind
  - xephyr
{% endcall %}

{% endif %}
