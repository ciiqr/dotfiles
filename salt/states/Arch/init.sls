{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/root.sls" as root with context %}

{% call pkg.all_installed(pillar) %}
  - pacman-tools
  - util-linux
  - yaourt
{% endcall %}

{{ sls }}.pkgfile.update:
  cmd.run:
    - name: pkgfile --update
    - onchanges:
      - pkg: {{ sls }}.pkg.pacman-tools

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
        repo_arch_tag: v2018.04.01.19.37.45
    - require_in:
      - pkg: {{ sls }}.pkg.yaourt

{{ sls }}.pacman.refresh_db:
  module.run:
    - pkg.refresh_db: []
    - onchanges:
      - file: {{ sls }}./etc/pacman.conf
