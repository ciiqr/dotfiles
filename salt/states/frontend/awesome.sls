{% import "macros/primary.sls" as primary with context %}
{% from "macros/common.sls" import os, platform with context %}

{% if not platform in ['windows', 'osx'] %}

{{ sls }}.link.~/.config/awesome:
  file.symlink:
    - name: {{ primary.home() }}/.config/awesome
    - target: {{ primary.home() }}/Projects/awesome
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - makedirs: true
    - force: true
    - onlyif: test -d '{{ primary.home() }}/Projects/awesome'

{{ sls }}.clone.~/.config/awesome:
  git.latest:
    - name: {{ salt['awesomewm.get_repo_url'](
      target = primary.home() ~ '/.config/awesome',
      user = primary.user()
    ) }}
    - target: {{ primary.home() }}/.config/awesome
    - user: {{ primary.user() }}
    - submodules: true
    - unless: test -d '{{ primary.home() }}/Projects/awesome'

{% if os == 'Void' %}

{{ sls }}.symlink.vicious:
  file.symlink:
    - target: /usr/share/lua/5.3/vicious
    - name: /usr/share/lua/5.2/vicious

{% endif %}

{% endif %}
