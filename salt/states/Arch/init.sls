{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/root.sls" as root with context %}
{% from "macros/common.sls" import roles with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}

{{ dotfiles.link_static() }}

{{ sls }}./etc/pacman.conf:
  file.managed:
    - name: /etc/pacman.conf
    - source: salt://{{ slspath }}/files/pacman.conf
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - template: jinja
    - context:
        repo_arch_tag: v2018.04.03.05.13.26
        chaotic_mirrorlist_exists: {{ salt['file.file_exists']('/etc/pacman.d/chaotic-mirrorlist') }}

{{ sls }}.pacman.refresh_db:
  module.run:
    - pkg.refresh_db: []
    - onchanges:
      - file: {{ sls }}./etc/pacman.conf

{% call pkg.all_installed() %}
  - pacman-tools
  - util-linux
{% endcall %}

{{ sls }}.pkgfile.update:
  cmd.run:
    - name: pkgfile --update
    - onchanges:
      - pkg: {{ sls }}.pkg.pacman-tools

# TODO: install yay
