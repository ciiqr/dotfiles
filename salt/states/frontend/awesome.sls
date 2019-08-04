{% import "macros/primary.sls" as primary with context %}
{% from "macros/common.sls" import os with context %}

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

{% if os == 'Void' %}

{{ sls }}.symlink.vicious:
  file.symlink:
    - target: /usr/share/lua/5.3/vicious
    - name: /usr/share/lua/5.2/vicious

{% endif %}
