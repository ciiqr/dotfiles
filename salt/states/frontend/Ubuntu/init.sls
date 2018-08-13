{% import "macros/pkg.sls" as pkg with context %}

{% call pkg.all_installed() %}
  - ubuntu-drivers-common
{% endcall %}

# Install the recommended driver packages (ie. nvidia, intel-microcode)
{{ sls }}.ubuntu_drivers:
  ubuntu_drivers.installed:
    - install_recommends: False
    - require:
      - pkg: {{ sls }}.pkg.ubuntu-drivers-common
