{% import "macros/primary.sls" as primary with context %}

{{ sls }}.perms:
  file.directory:
    - name: {{ primary.home() }}/.ssh
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - dir_mode: 700
    - file_mode: 600
    - recurse:
      - user
      - group
      - mode
