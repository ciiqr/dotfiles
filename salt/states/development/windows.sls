{% from "macros/common.sls" import roles with context %}

python2: chocolatey.installed
python3: chocolatey.installed

{% if 'frontend' in roles %}
sublimetext3: chocolatey.installed
github: chocolatey.installed
babun: chocolatey.installed
virtualbox: chocolatey.installed
{% endif %}
