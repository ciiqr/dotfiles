{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/root.sls" as root with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}

{{ dotfiles.link_static() }}

{% call pkg.all_installed() %}
  - xtools
  - util-linux
{% endcall %}

{{ sls }}.xlocate.update:
  cmd.run:
    - name: xlocate -S
    - onchanges:
      - pkg: {{ sls }}.pkg.xtools
