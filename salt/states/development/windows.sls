{% from "macros/common.sls" import roles with context %}

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
{% endif %}
