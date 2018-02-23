{% from slspath + "/map.jinja" import frontend with context %}
{% import "macros/pkg.sls" as pkg with context %}

{{ pkg.installed('baobab', frontend) }}
