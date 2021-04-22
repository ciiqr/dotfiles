{% from "macros/common.sls" import roles with context %}
{% import "macros/primary.sls" as primary with context %}

python2: chocolatey.installed
python3: chocolatey.installed
docker-desktop: chocolatey.installed

{% if 'frontend' in roles %}

sublimetext3: chocolatey.installed
alacritty: chocolatey.installed
virtualbox: chocolatey.installed
vscode: chocolatey.installed
rufus: chocolatey.installed
dotpeek: chocolatey.installed

{{ sls }}.config.alacritty:
  file.managed:
    - name: C:\Users\william\AppData\Roaming\alacritty\alacritty.yml
    - source: salt://{{ slspath }}/files/alacritty-windows.yml
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - makedirs: true
    - template: jinja

{% endif %}
