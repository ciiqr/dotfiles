{% set development = pillar.get('development', {}) %}

# TODO: support dictionary based pkg pillars so we can set things like this up normally: elif package is mapping
# Vagrant
{{ sls }}.pkg.vagrant: # TODO: how best to handle version and grains (can I use jinja in pillar stack for this?)
  pkg.installed:
    - sources:
      - vagrant: https://releases.hashicorp.com/vagrant/{{ development.vagrant.version }}/vagrant_{{ development.vagrant.version }}_{{ grains['cpuarch'] }}.deb
