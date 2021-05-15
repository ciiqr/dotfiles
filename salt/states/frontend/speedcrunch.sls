{% import "macros/primary.sls" as primary with context %}

{% set speedcrunch = salt['grains.filter_by']({
    'linux': {
        'path': '.config/SpeedCrunch',
    },
    'osx': {
        'path': 'Library/Preferences/SpeedCrunch',
    },
    'windows': {
        'path': 'AppData/Roaming/SpeedCrunch',
    },
}, grain='platform') %}

{{ sls }}.SpeedCrunch.ini:
  ini.options_present:
    - name: {{ primary.home() }}/{{ speedcrunch.path }}/SpeedCrunch.ini
    - sections:
        SpeedCrunch:
          Format\ComplexForm: c
          Format\Precision: -1
          Format\Type: f
    - unless: test ! -f {{ primary.home() }}/{{ speedcrunch.path }}/SpeedCrunch.ini
