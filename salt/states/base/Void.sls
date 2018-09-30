{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/root.sls" as root with context %}

# TODO: do I even need this?... probs not
# {{ sls }}.xbps-alternatives-locate:
#   cmd.run:
#     - name: sudo xbps-alternatives -s mlocate -g locate
#     - require:
#       - base.pkg.mlocate
