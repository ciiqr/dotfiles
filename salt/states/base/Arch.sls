{% import "macros/service.sls" as service with context %}
{% import "macros/primary.sls" as primary with context %}

{% if 'git.checkout' in salt %}

{{ sls }}.yay.latest:
  git.latest:
    - name: https://aur.archlinux.org/yay.git
    - target: {{ primary.home() }}/.cache/config/yay
    - user: {{ primary.user() }}

{{ sls }}.yay.install:
  cmd.run:
    - name: makepkg -si
    - cwd: {{ primary.home() }}/.cache/config/yay
    - runas: {{ primary.user() }}
    - onchanges:
      - git: {{ sls }}.yay.latest

{{ sls }}.repos.chaotic:
  cmd.run:
    - name: yay -S chaotic-keyring chaotic-mirrorlist --noconfirm
    - runas: {{ primary.user() }}
    - onchanges:
      - cmd: {{ sls }}.yay.install

{% endif %}

# services
{% call service.running('man-db') %}
    - require:
      - pkg: base.pkg.man
{% endcall %}

{% call service.running('updatedb') %}
    - require:
      - pkg: base.pkg.mlocate
{% endcall %}
