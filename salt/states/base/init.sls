{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/root.sls" as root with context %}
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
  - coreutils
  - awk

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
  - openssl

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

  # Shells
  - zsh
  - bash

  # Terminfo
  - terminfo

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
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644

{% endif %}

{% if not platform in ['windows', 'osx'] %}

# Password less sudo
{{ sls }}./etc/sudoers.d/user-{{ primary.user() }}:
  file.managed:
    - name: /etc/sudoers.d/user-{{ primary.user() }}
    - source: salt://{{ slspath }}/files/sudoers-user
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
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
    - user: {{ root.user() }}
    - group: {{ root.group() }}
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
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - onchanges_in:
      - cmd: {{ sls }}.refresh-sysctl

{{ sls }}.refresh-sysctl:
  cmd.run:
    - name: sysctl --system

{% endif %}

{% if not platform in ['windows'] %}
# Updatedb
# TODO: move to file and load that
{% load_yaml as prune_paths %}
  - /tmp
  - /var/tmp
  - /var/spool
  - /media
  - /home/.ecryptfs
  - /var/lib/schroot
  - /etc/mono/certstore/certs
  - /etc/ssl/certs
  - {{ primary.home() }}/.cache
  - {{ primary.home() }}/.config/google-chrome
  - {{ primary.home() }}/.mozilla
{% endload %}

# TODO: go through paths from arch: PRUNEPATHS = "/afs /mnt /net /sfs /udev /var/cache /var/lib/pacman/local /var/lock /var/run"

{{ sls }}.locate.PRUNEPATHS:
  file.replace:
    - name: {{ base.get('locate_conf_path') }}
    - pattern: ^[ \t]*PRUNEPATHS[ \t]*=[ \t]*"(.*)"
    - repl: PRUNEPATHS="{{ prune_paths|join(' ') }}"
    - append_if_not_found: true

{% endif %}

# services
{% call service.running('haveged', base) %}
    - require:
      - pkg: {{ sls }}.pkg.haveged
{% endcall %}

{# call service.running('smartmontools', base) #}
{#     - require: #}
{#       - pkg: {{ sls }}.pkg.smartmontools #}
{# endcall #}
