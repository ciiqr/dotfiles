{% import "macros/primary.sls" as primary with context %}
{% from "macros/common.sls" import os, platform with context %}

{% if not platform in ['windows', 'osx'] %}

{{ sls }}.~/.local/bin/subl3:
  file.symlink:
    - name: {{ primary.home() }}/.config/awesome
    - target: {{ primary.home() }}/Projects/awesome
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - makedirs: true
    - force: true
    - onlyif: test -d '{{ primary.home() }}/Projects/awesome'

# Install my awesome config
{{ sls }}.~/.config/awesome:
  git.latest:
    - name: {{ salt['awesomewm.get_repo_url'](
      target = primary.home() ~ '/.config/awesome',
      user = primary.user()
    ) }}
    - target: {{ primary.home() }}/.config/awesome
    - user: {{ primary.user() }}
    - submodules: true
    - force_reset: {{ salt['gitutils.update_required_with_only_irrelevant_local_changes'](
      'https://github.com/ciiqr/awesome.git',
      target = primary.home() ~ '/.config/awesome',
      user = primary.user()
    ) }}
    - unless: test -d '{{ primary.home() }}/Projects/awesome'

{% if os == 'Void' %}

{{ sls }}.symlink.vicious:
  file.symlink:
    - target: /usr/share/lua/5.3/vicious
    - name: /usr/share/lua/5.2/vicious

{% endif %}

{% endif %}
