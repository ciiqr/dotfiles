{% import "macros/path.sls" as path with context %}
{% import "macros/primary.sls" as primary with context %}

{% set base = pillar.get('base', {}) %}

# TODO: likely doesn't need to be completely platform specific...
# android
{{ sls }}.src.android-sdk-tools:
  archive.extracted:
    - name: {{ base.src_path }}/android-sdk-tools-4333796
    # SOURCE: https://developer.android.com/studio/#command-tools
    - source: https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
    - source_hash: sha256=92ffee5a1d98d856634e8b71132e8a95d96c83a63fde1099be3d86df3106def9
    - enforce_toplevel: false
    - if_missing: {{ base.src_path }}/android-sdk-tools-4333796

{{ sls }}.perms.android-sdk-tools:
  cmd.run:
    - name: chmod -R 0777 {{ base.src_path }}/android-sdk-tools-4333796/tools
    - onchanges:
      - {{ sls }}.src.android-sdk-tools

{{ sls }}.android-repositories:
  file.managed:
  - name: {{ primary.home() }}/.android/repositories.cfg
  - user: {{ primary.user() }}
  - group: {{ primary.group() }}
  - makedirs: true

{% set sdkmanager = base.src_path ~ '/android-sdk-tools-4333796/tools/bin/sdkmanager' %}

{{ sls }}.accept-android-sdk-licenses:
  cmd.run:
    - name: yes | {{ sdkmanager }} --licenses
    - onchanges:
      - {{ sls }}.src.android-sdk-tools

{{ sls }}.platform-tools:
  cmd.run:
    - name: {{ sdkmanager }} --install platform-tools
    - onchanges:
      - {{ sls }}.src.android-sdk-tools

{{ sls }}.platforms:
  cmd.run:
    - name: {{ sdkmanager }} --install 'platforms;android-28'
    - onchanges:
      - {{ sls }}.src.android-sdk-tools

{{ sls }}.sources:
  cmd.run:
    - name: {{ sdkmanager }} --install 'sources;android-28'
    - onchanges:
      - {{ sls }}.src.android-sdk-tools

{{ sls }}.build-tools:
  cmd.run:
    - name: {{ sdkmanager }} --install 'build-tools;28.0.3'
    - onchanges:
      - {{ sls }}.src.android-sdk-tools

{{ sls }}.symlink.opt-android-sdk:
  file.symlink:
    - target: {{ base.src_path }}/android-sdk-tools-4333796
    - name: /opt/android-sdk

# Add android sdk tools to PATH
{{ path.global('android-sdk-tools', '/opt/android-sdk/platform-tools:/opt/android-sdk/tools/bin') }}


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
    - name: {{ base.src_path }}/flutter-1.0.0/flutter
    # TODO: ugh, should probably install to user dir...
    - mode: 777
    - recurse:
      - mode
    - require:
      - {{ sls }}.src.flutter


# Add flutter to PATH
{{ path.global('flutter', base.src_path ~ '/flutter-1.0.0/flutter/bin') }}
{{ path.global('dart', base.src_path ~ '/flutter-1.0.0/flutter/bin/cache/dart-sdk/bin') }}
