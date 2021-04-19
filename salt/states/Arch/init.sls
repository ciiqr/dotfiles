{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/root.sls" as root with context %}
{% from "macros/common.sls" import roles with context %}

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

{{ sls }}.pacman.refresh_db:
  module.run:
    - pkg.refresh_db: []
    - onchanges:
      - file: {{ sls }}./etc/pacman.conf

{% call pkg.all_installed() %}
  - pacman-tools
  - util-linux
  - console-font
{% endcall %}

{{ sls }}.pkgfile.update:
  cmd.run:
    - name: pkgfile --update
    - onchanges:
      - pkg: {{ sls }}.pkg.pacman-tools

# TODO: install yay

{% if 'hidpi' in roles %}

# NOTE: we only set this up if the font package was actually installed (this way we don't setup this config with an invalid font)
{{ sls }}./boot/loader/entries/hidpi.conf:
  file.managed:
    - name: /boot/loader/entries/hidpi.conf
    - source: salt://{{ slspath }}/files/bootloader-hidpi.conf
    # - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 755
    - onchanges:
      - pkg: {{ sls }}.pkg.console-font

{{ sls }}./etc/vconsole.conf:
  file.managed:
    - name: /etc/vconsole.conf
    - source: salt://{{ slspath }}/files/vconsole.conf
    # - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - onchanges:
      - pkg: {{ sls }}.pkg.console-font

{% endif %}
