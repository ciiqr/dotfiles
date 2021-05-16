{% import "macros/primary.sls" as primary with context %}

{% set speedcrunch = salt['grains.filter_by']({
    'linux': {
        'config_path': '.config/SpeedCrunch',
        'cache_path': '.local/share/SpeedCrunch',
    },
    'osx': {
        'config_path': 'Library/Preferences/SpeedCrunch',
        'cache_path': 'Library/Application Support/SpeedCrunch',
    },
    'windows': {
        'config_path': 'AppData/Roaming/SpeedCrunch',
        'cache_path': 'AppData/Roaming/SpeedCrunch',
    },
}, grain='platform') %}

# settings
{{ sls }}.SpeedCrunch.ini:
  ini.options_present:
    - name: {{ primary.home() }}/{{ speedcrunch.config_path }}/SpeedCrunch.ini
    - sections:
        SpeedCrunch:
          Format\ComplexForm: c
          Format\Precision: -1
          Format\Type: f
    - unless: test ! -f {{ primary.home() }}/{{ speedcrunch.config_path }}/SpeedCrunch.ini

# user functions/etc
# NOTE: because this also contains history, we only write this if it doesn't exist
{{ sls }}.history.json:
  file.managed:
    - name: {{ primary.home() }}/{{ speedcrunch.cache_path }}/history.json
    - source: salt://{{ slspath }}/files/speedcrunch-history.json
    - makedirs: true
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - mode: 644
    - unless: test -f '{{ primary.home() }}/{{ speedcrunch.cache_path }}/history.json'
