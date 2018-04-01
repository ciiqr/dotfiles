{% import "macros/pkg.sls" as pkg with context %}

{% call pkg.all_installed(pillar) %}
  - apt-tools
  - debconf-utils
{% endcall %}

# TODO: Update apt-file (creates /var/cache/apt/apt-file/*)
# TODO: sensors-detect --auto
