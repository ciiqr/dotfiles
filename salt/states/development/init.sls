{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% from "macros/common.sls" import role_includes, roles with context %}

{% set development = pillar.get('development', {}) %}

{% call optional.include() %}
  - .git
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

# TODO: support dictionary based pkg pillars so we can set things like this up normally
# # Vagrant
# {{ sls }}.pkg.vagrant:
#   pkg.installed:
#     - sources:
#       - vagrant: https://releases.hashicorp.com/vagrant/{{ development.vagrant.version }}/vagrant_{{ development.vagrant.version }}_{{ grains['cpuarch'] }}.deb

# TODO: Terraform and Packer
# declare -A hashi_packages=(
#   [terraform]="0.10.8"
#   [packer]="1.1.1"
# )

# for hashi_package in "${!hashi_packages[@]}"; do
#   declare version="${hashi_packages[$hashi_package]}"

#   # Download
#   wget "https://releases.hashicorp.com/${hashi_package}/${version}/${hashi_package}_${version}_linux_amd64.zip" -O "$hashi_package.zip"

#   # Install
#   sudo mkdir -p "/opt/$hashi_package"
#   sudo unzip -o "$hashi_package.zip" -d "/opt/$hashi_package"

#   # Delete zip
#   rm "$hashi_package.zip"

#   # Add to PATH
#   tee "/etc/profile.d/$hashi_package.sh" > /dev/null <<EOF

#   export PATH="/opt/$hashi_package:\$PATH"
# EOF
# done


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
