{% from "macros/common.sls" import roles with context %}

{% if 'frontend' in roles %}
steam: chocolatey.installed
discord: chocolatey.installed
twitch: chocolatey.installed
battle.net: chocolatey.installed
nvidia-geforce-now: chocolatey.installed

nvidia-display-driver:
  chocolatey.installed:
    - onlyif: wmic path win32_VideoController get AdapterCompatibility | findstr -I nvidia
{% endif %}
