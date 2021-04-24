{% import "macros/primary.sls" as primary with context %}

{{ sls }}.hide.~/Music:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh {{ primary.home() }}/Music
    - stateful: true

{{ sls }}.hide.~/Public:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh {{ primary.home() }}/Public
    - stateful: true

{{ sls }}.hide.~/Applications:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh {{ primary.home() }}/Applications
    - stateful: true

{{ sls }}.hide.~/Documents:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh {{ primary.home() }}/Documents
    - stateful: true

{{ sls }}.hide.~/Movies:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh {{ primary.home() }}/Movies
    - stateful: true

{{ sls }}.hide.~/Pictures:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh {{ primary.home() }}/Pictures
    - stateful: true
