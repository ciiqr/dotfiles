{% import "macros/pkg.sls" as pkg with context %}

{% set base = pillar.get('base', {}) %}

{% call pkg.all_installed(base) %}
  # TODO: maybe these belong in Debian instead, but have to move pillars also
  - apt-tools
  - debconf-utils
{% endcall %}
