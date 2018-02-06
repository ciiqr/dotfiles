
python2: chocolatey.installed
python3: chocolatey.installed

{% if 'frontend' in __grains__['roles'] %}
sublimetext3: chocolatey.installed
sublimetext3.packagecontrol: chocolatey.installed
github: chocolatey.installed
babun: chocolatey.installed
{% endif %}
