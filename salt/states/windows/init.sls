{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% from "macros/common.sls" import platform_includes with context %}

{% call optional.include() %}
  - .programs
  - .tweaks
  {{ platform_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}

# Gridmove
{{ sls }}.gridmove.layout.thrizen:
  file.managed:
    - name: C:\Program Files (x86)\GridMove\Grids\thrizen3000.grid
    - source: salt://{{ slspath }}/files/thrizen3000.grid
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - makedirs: true

{{ sls }}.gridmove.layouts.directory:
  file.directory:
    - name: C:\Program Files (x86)\GridMove\Grids
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - makedirs: true
    - clean: true
    - require:
      - file: {{ sls }}.gridmove.layout.thrizen
