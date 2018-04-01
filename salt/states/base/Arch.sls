{% import "macros/service.sls" as service with context %}

# services
{% call service.running('man-db', pillar) %}
    - require:
      - pkg: base.pkg.man
{% endcall %}

{% call service.running('updatedb', pillar) %}
    - require:
      - pkg: base.pkg.mlocate
{% endcall %}
