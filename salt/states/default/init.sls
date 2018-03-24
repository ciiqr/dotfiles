{% import "macros/optional.sls" as optional with context %}
{% import "macros/primary.sls" as primary with context %}
{% from "macros/common.sls" import role_includes, platform with context %}

{% set default = salt['pillar.get']('default', {}) %}

{% call optional.include() %}
  {{ role_includes() }}
{%- endcall %}

# Hostname
{{ sls }}.hostname:
  hostname.system:
    - name: {{ default.get('hostname', grains['id']) }}

# Timezone
{{ sls }}.timezone:
  timezone.system:
    - name: America/Toronto
    - utc: true

# TODO: ie. vconsole.conf
# Keyboard selection
# layout us
# layout English (US)
# variant English (US)

# TODO: is anything required/possible beyond preseed? is this applicable beyond debian?
# Prevent 'toggling between national and Latin mode'
# keyboard-configuration/toggle No toggling

# Localization
{% if not platform in ['windows'] %}

{% if not platform in ['osx'] %}
{{ sls }}.locale:
  locale.system:
    - name: en_CA.UTF-8
    - require:
      - locale: {{ sls }}.locale.en_ca
{% endif %}

{{ sls }}.locale.en_ca:
  locale.present:
    - name: en_CA.UTF-8

# User
{% set user = salt['user.info'](primary.user()) %}

{% if not user %}
{{ sls }}.primary-user-group:
  group.present:
    - name: {{ primary.user() }}
    - gid: {{ user.get('gid', 1000) }}
{% endif %}

{{ sls }}.primary-user:
  user.present:
    - name: {{ primary.user() }}
    - fullname: 'William Villeneuve'
    - shell: /bin/zsh
    - home: /home/{{ primary.user() }}
    - uid: {{ user.get('uid', 1000) }}
    - gid: {{ user.get('gid', 1000) }}
    - groups:
      - {{ primary.group() }}
    - remove_groups: False
{% if not user %}
    - require:
      - group: {{ sls }}.primary-user-group
{% endif %}

{% endif %}
