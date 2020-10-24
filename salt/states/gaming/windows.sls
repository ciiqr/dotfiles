{% from "macros/common.sls" import roles with context %}

{% if 'frontend' in roles %}
steam: chocolatey.installed
discord: chocolatey.installed
battle.net: chocolatey.installed
nvidia-geforce-now: chocolatey.installed

# TODO: install https://wowup.io/

nvidia-display-driver:
  chocolatey.installed:
    - onlyif: wmic path win32_VideoController get AdapterCompatibility | findstr -I nvidia
{% endif %}
