{% import "macros/primary.sls" as primary with context %}

{{ sls }}.hide.~/Music:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh hide {{ primary.home() }}/Music
    - stateful: true

{{ sls }}.hide.~/Public:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh hide {{ primary.home() }}/Public
    - stateful: true

{{ sls }}.hide.~/Applications:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh hide {{ primary.home() }}/Applications
    - stateful: true

{{ sls }}.hide.~/Documents:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh hide {{ primary.home() }}/Documents
    - stateful: true

{{ sls }}.hide.~/Movies:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh hide {{ primary.home() }}/Movies
    - stateful: true

{{ sls }}.hide.~/Pictures:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh hide {{ primary.home() }}/Pictures
    - stateful: true

{{ sls }}.hide.~/Desktop:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh hide {{ primary.home() }}/Desktop
    - stateful: true

{{ sls }}.show./Volumes:
  cmd.script:
    - source: salt://{{ slspath }}/files/hide.sh
    - name: hide.sh show /Volumes
    - stateful: true
