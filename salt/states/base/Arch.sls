{% import "macros/service.sls" as service with context %}

# services
{% call service.running('man-db') %}
    - require:
      - pkg: base.pkg.man
{% endcall %}

{% call service.running('updatedb') %}
    - require:
      - pkg: base.pkg.mlocate
{% endcall %}
