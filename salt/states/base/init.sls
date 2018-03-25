{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/service.sls" as service with context %}
{% from "macros/common.sls" import role_includes, platform with context %}

{% set base = pillar.get('base', {}) %}

{% call optional.include() %}
  - .omz
  {{ role_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}

{% call pkg.all_installed(base) %}
  - kernel

  # Misc
  - libcap
  - man
  - info
  - wget
  - nfs
  - woof
  - htop
  - whois
  - ssh
  - sshfs
  - nano
  - p7zip
  - rsync
  - mlocate
  - incron
  - lsof
  - nmap
  - screen
  - units
  - unrar
  - zip
  - traceroute
  - fdupes
  - jq
  - colordiff

  # Hardware info
  - lshw
  - hwinfo

  # Sensors
  - lm-sensors

  # Services
  # TODO: try chrony
  - ntp
  - haveged
  - smartmontools

  # Zsh
  - zsh

  # TODO: this is required in base if we're going to use git install omz, but it's not really required otherwise... maybe doesn't matter
  - git
{% endcall %}

# TODO: need paths for these...
# 'FreeBSD': {
#   'configpath': '/usr/local/etc',
#   'includedir': '/usr/local/etc/sudoers.d',
#   'execprefix': '/usr/local/sbin',
# }

{% if base.get('packages', {}).get('zsh') %}

# Make sure zsh works properly... sigh ubuntu
# NOTE: this may not be required on all platforms, but unless it breaks something, I'll leave it here.
{% set zsh_etc_path = salt['pillar.get']('base:zsh_etc_path', '/etc/zsh') %}
{{ sls }}.{{ zsh_etc_path }}/zprofile:
  file.managed:
    - name: {{ zsh_etc_path }}/zprofile
    - source: salt://{{ slspath }}/files/zprofile
    - makedirs: true
    - user: root
    - group: root
    - mode: 644

{% endif %}

{% if not platform in ['windows', 'osx'] %}

# Password less sudo
{{ sls }}./etc/sudoers.d/user-{{ primary.user() }}:
  file.managed:
    - name: /etc/sudoers.d/user-{{ primary.user() }}
    - source: salt://{{ slspath }}/files/sudoers-user
    - makedirs: true
    - user: root
    - group: root
    - mode: 440
    - check_cmd: {{ base.get('execprefix', '/usr/sbin') }}/visudo -c -f
    - template: jinja
    - context:
        user: {{ primary.user() }}

# Override sudo defaults
{{ sls }}./etc/sudoers.d/defaults:
  file.managed:
    - name: /etc/sudoers.d/defaults
    - source: salt://{{ slspath }}/files/sudoers-defaults
    - makedirs: true
    - user: root
    - group: root
    - mode: 440
    - check_cmd: {{ base.get('execprefix', '/usr/sbin') }}/visudo -c -f
    - template: jinja
    - context:
        user: {{ primary.user() }}

# sysctl
{{ sls }}./etc/sysctl.d/100-sysctl.conf:
  file.managed:
    - name: /etc/sysctl.d/100-sysctl.conf
    - source: salt://{{ slspath }}/files/100-sysctl.conf
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - onchanges_in:
      - cmd: {{ sls }}.refresh-sysctl

{{ sls }}.refresh-sysctl:
  cmd.run:
    - name: sysctl --system

{% endif %}

# TODO: implement
# # Updatedb
# ADDITIONAL_PRUNE_PATHS="$user_home/.cache $user_home/.config/google-chrome $user_home/.mozilla /etc/mono/certstore/certs /etc/ssl/certs"
# # TODO: Replace with replace_or_append (need to make sure I can use replacements... well I can at least grab the data I want first then find/replace)
# sed -i 's@[# ]*PRUNEPATHS="\(.*\)"@PRUNEPATHS="\1 '"$ADDITIONAL_PRUNE_PATHS"'"@;s@[# ]*PRUNENAMES="\(.*\)"@PRUNENAMES="\1"@' /etc/updatedb.conf

# services
{% call service.running('haveged', base) %}
    - require:
      - pkg: {{ sls }}.pkg.haveged
{% endcall %}

{# call service.running('smartmontools', base) #}
{#     - require: #}
{#       - pkg: {{ sls }}.pkg.smartmontools #}
{# endcall #}
