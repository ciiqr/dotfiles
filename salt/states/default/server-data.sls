{% import "macros/pkg.sls" as pkg with context %}

{% set server_data = pillar.get('server-data', {}) %}

{{ pkg.installed('acl', server_data) }}
