{% import "macros/primary.sls" as primary with context %}

{% macro install(name) %}

{{ sls }}.pkg.{{ name }}:
  cmd.run:
    - name: . ~/.nvm/nvm.sh && npm install -g {{ name }}
    - runas: {{ primary.user() }}
    - unless: . ~/.nvm/nvm.sh && npm list -g {{ name }} && npm outdated -g {{ name }}

{% endmacro %}
