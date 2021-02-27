{% import "macros/optional.sls" as optional with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/root.sls" as root with context %}
{% from "macros/common.sls" import role_includes, platform, os with context %}

{% set default = salt['pillar.get']('default', {}) %}

{% call optional.include() %}
  {{ role_includes() }}
{%- endcall %}

# Hostname
{% if not platform in ['windows'] %}

{{ sls }}.hostname:
  hostname.system:
    - name: {{ default.get('hostname', grains['id']) }}

# TODO: merge this into above?
{{ sls }}.hostname.preserve:
  file.managed:
    - name: /etc/hostname
    - contents: {{ default.get('hostname', grains['id']) }}
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644

{% else %}
# TODO: move this?

{{ sls }}.computer_name:
  system.computer_name:
    - name: {{ default.get('hostname', grains['id']) }}

{{ sls }}.hostname:
  system.hostname:
    - name: {{ default.get('hostname', grains['id']) }}

{% endif %}

# Timezone
{{ sls }}.timezone:
  timezone.system:
# TODO: dumb, move to pillar
{% if not platform in ['windows'] %}
    - name: America/Toronto
    - utc: true
{% else %}
    - name: Eastern Standard Time
    - utc: false
{% endif %}

# TODO: ie. vconsole.conf
# Keyboard selection
# layout us
# layout English (US)
# variant English (US)

# TODO: is anything required/possible beyond preseed? is this applicable beyond debian?
# Prevent 'toggling between national and Latin mode'
# keyboard-configuration/toggle No toggling

# Localization
{% if not platform in ['windows'] and not os in ['Void'] %}

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

{% endif %}

{% if not platform in ['windows'] %}

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
{% if user %}
    - home: {{ primary.home() }}
{% else %}
    - home: /home/{{ primary.user() }}
{% endif %}
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
