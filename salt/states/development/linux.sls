{% import "macros/path.sls" as path with context %}

{% set base = pillar.get('base', {}) %}

# TODO: likely doesn't need to be completely platform specific...
# flutter
{{ sls }}.src.flutter:
  archive.extracted:
    - name: {{ base.src_path }}/flutter-1.0.0
    - source: https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.0.0-stable.tar.xz
    - skip_verify: true
    - enforce_toplevel: false
    - if_missing: {{ base.src_path }}/flutter-1.0.0

{{ sls }}.perms.flutter:
  file.directory:
    - name: {{ base.src_path }}/flutter-1.0.0/flutter/bin
    - mode: 755
    - recurse:
      - mode
    - require:
      - {{ sls }}.src.flutter


# Add flutter to PATH
{{ path.global('flutter', base.src_path ~ '/flutter-1.0.0/flutter/bin') }}
