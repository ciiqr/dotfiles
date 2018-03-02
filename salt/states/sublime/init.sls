{% from slspath + "/map.jinja" import sublime with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/optional.sls" as optional with context %}
{% from "macros/common.sls" import platform with context %}

{% call optional.include() %}
  - private.{{ sls }}
  - .{{ platform }}
  - private.{{ sls }}.{{ platform }}
{%- endcall %}

{% set sublime_path = primary.home() ~ '/' ~ sublime.path %}

{{ sls }}.Installed Packages:
  file.directory:
    - name: {{ sublime_path }}/Installed Packages
    - user: {{ primary.user() }}
    {% if not platform == 'windows' %}
    - group: {{ primary.group() }}
    {% endif %}
    - makedirs: true
    - dir_mode: 700
    - file_mode: 600
    - recurse:
      {% if not platform == 'windows' %}
      - user
      - group
      {% endif %}
      - mode

{{ sls }}.Packages/User:
  file.directory:
    - name: {{ sublime_path }}/Packages/User
    - user: {{ primary.user() }}
    {% if not platform == 'windows' %}
    - group: {{ primary.group() }}
    {% endif %}
    - makedirs: true
    - dir_mode: 700
    - file_mode: 600
    - recurse:
      {% if not platform == 'windows' %}
      - user
      - group
      {% endif %}
      - mode


{{ sls }}.Installed Packages/Package Control.sublime-package:
  file.managed:
    - name: {{ sublime_path }}/Installed Packages/Package Control.sublime-package
    - source: https://packagecontrol.io/Package%20Control.sublime-package
    - skip_verify: true # TODO: ugh external things
    - user: {{ primary.user() }}
    {% if not platform == 'windows' %}
    - group: {{ primary.group() }}
    - mode: 600
    {% endif %}
    - require:
      - file: {{ sls }}.Installed Packages


{{ sls }}.Packages/User/Package Control.sublime-settings:
  file.managed:
    - name: {{ sublime_path }}/Packages/User/Package Control.sublime-settings
    - source: salt://{{ slspath }}/files/Package Control.sublime-settings
    - user: {{ primary.user() }}
    {% if not platform == 'windows' %}
    - group: {{ primary.group() }}
    - mode: 600
    {% endif %}
    - template: jinja
    - require:
      - file: {{ sls }}.Packages/User
    - context:
        sublime: {{ sublime }}

{{ sls }}.Packages/User/Preferences.sublime-settings:
  file.managed:
    - name: {{ sublime_path }}/Packages/User/Preferences.sublime-settings
    - source: salt://{{ slspath }}/files/Preferences.sublime-settings
    - user: {{ primary.user() }}
    {% if not platform == 'windows' %}
    - group: {{ primary.group() }}
    - mode: 600
    {% endif %}
    - template: jinja
    - require:
      - file: {{ sls }}.Packages/User
    - context:
        sublime: {{ sublime }}

{{ dotfiles.link_static('/config', sublime.path ~ '/Packages/User/') }}
