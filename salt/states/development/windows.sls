{% from "macros/common.sls" import roles with context %}

synctrayzor: chocolatey.installed
python3: chocolatey.installed

{% if 'frontend' in roles %}
sublimetext3: chocolatey.installed
github: chocolatey.installed
alacritty: chocolatey.installed
virtualbox: chocolatey.installed
vscode: chocolatey.installed
{% endif %}
