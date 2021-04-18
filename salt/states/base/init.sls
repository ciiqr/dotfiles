{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/root.sls" as root with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/service.sls" as service with context %}
{% from "macros/common.sls" import role_includes, platform, os with context %}

{% set base = pillar.get('base', {}) %}

{% call optional.include() %}
  - .omz
  - .neovim
  {{ role_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}

{% call pkg.all_installed() %}
  - kernel
  - coreutils
  - awk
  - bc
  - rename

  # Misc
  - libcap
  - less
  - man
  - info
  - wget
  - nfs
  - woof
  - htop
  - whois
  - ssh
  - sshfs
  - neovim
  - p7zip
  - rsync
  - mlocate
  - cronie
  - incron
  - lsof
  - nmap
  - screen
  - tmux
  - units
  - unrar
  - zip
  - traceroute
  - fdupes
  - jq
  - yq
  - colordiff
  - cwdiff
  - openssl
  - watch
  - parallel
  - bind-utils # TODO: look into how this translates to non-void os's (void provides dig, host, and nslookup)
  - moreutils

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

  # Tree
  - tree

  # TODO: this is required in base if we're going to use git install omz, but it's not really required otherwise... maybe doesn't matter
  - git
{% endcall %}

# TODO: need paths for these...
# 'FreeBSD': {
#   'configpath': '/usr/local/etc',
#   'includedir': '/usr/local/etc/sudoers.d',
#   'execprefix': '/usr/local/sbin',
# }

{% if pillar.get('packages', {}).get('zsh') %}

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

{% if not platform in ['windows'] %}

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
{% endif %}

{% if not platform in ['windows', 'osx'] %}
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
# TODO: change to a file template?

{% load_yaml as prune_paths %}
  - /tmp
  - /var/tmp
  - /var/spool
  - /var/cache
  - /media
  - /mnt
  - /home/.ecryptfs
  - /var/lib/schroot
  - /var/lib/docker
  - /etc/mono/certstore/certs
  - /etc/ssl/certs
  - /afs
  - /net
  - /sfs
  - /udev
  - /var/lib/pacman/local
  - /var/lock
  - /var/run
  - {{ primary.home() }}/.cache
  - {{ primary.home() }}/.config/google-chrome
  - {{ primary.home() }}/.config/chromium
  - {{ primary.home() }}/.mozilla
  - {{ primary.home() }}/.npm/_cacache
  - {{ primary.home() }}/.local/share/lutris/runners
  - {{ primary.home() }}/.local/share/lutris/runtime
  - {{ primary.home() }}/.local/share/Steam
  - {{ primary.home() }}/.wine
  - {{ primary.home() }}/External
  - {{ primary.home() }}/Games
{% endload %}
{% load_yaml as prune_names %}
  - node_modules
  - .git
  - .hg
  - .svn
  - .build
{% endload %}
{% load_yaml as prune_fs %}
  - 9p
  - afs
  - anon_inodefs
  - auto
  - autofs
  - bdev
  - binfmt_misc
  - cgroup
  - cifs
  - coda
  - configfs
  - cpuset
  - cramfs
  - debugfs
  - devpts
  - devtmpfs
  - ecryptfs
  - exofs
  - ftpfs
  - fuse
  - fuse.encfs
  - fuse.sshfs
  - fusectl
  - gfs
  - gfs2
  - hugetlbfs
  - inotifyfs
  - iso9660
  - jffs2
  - lustre
  - mqueue
  - ncpfs
  - nfs
  - nfs4
  - nfsd
  - pipefs
  - proc
  - ramfs
  - rootfs
  - rpc_pipefs
  - securityfs
  - selinuxfs
  - sfs
  - shfs
  - smbfs
  - sockfs
  - sshfs
  - sysfs
  - tmpfs
  - ubifs
  - udf
  - usbfs
  - vboxsf
{% endload %}

{{ sls }}.locate.etc:
  file.managed:
    - name: {{ base.get('locate_conf_path') }}
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - replace: false

{{ sls }}.locate.PRUNE_BIND_MOUNTS:
  file.replace:
    - name: {{ base.get('locate_conf_path') }}
    - pattern: ^[ \t]*PRUNE_BIND_MOUNTS[ \t]*=[ \t]*"(.*)"
    - repl: PRUNE_BIND_MOUNTS="yes"
    - append_if_not_found: true

{{ sls }}.locate.PRUNEFS:
  file.replace:
    - name: {{ base.get('locate_conf_path') }}
    - pattern: ^[ \t]*PRUNEFS[ \t]*=[ \t]*"(.*)"
    - repl: PRUNEFS="{{ prune_fs|join(' ') }}"
    - append_if_not_found: true

{{ sls }}.locate.PRUNENAMES:
  file.replace:
    - name: {{ base.get('locate_conf_path') }}
    - pattern: ^[ \t]*PRUNENAMES[ \t]*=[ \t]*"(.*)"
    - repl: PRUNENAMES="{{ prune_names|join(' ') }}"
    - append_if_not_found: true

{{ sls }}.locate.PRUNEPATHS:
  file.replace:
    - name: {{ base.get('locate_conf_path') }}
    - pattern: ^[ \t]*PRUNEPATHS[ \t]*=[ \t]*"(.*)"
    - repl: PRUNEPATHS="{{ prune_paths|join(' ') }}"
    - append_if_not_found: true

# default ssh key
{{ sls }}.ssh.key:
  cmd.run:
    - name: ssh-keygen -t rsa -b 4096 -o -N "" -f ~/.ssh/id_rsa
    - runas: {{ primary.user() }}
    - unless: test -f ~/.ssh/id_rsa

{% endif %}

# services
{% call service.running('haveged') %}
    - require:
      - pkg: {{ sls }}.pkg.haveged
{% endcall %}

{# call service.running('smartmontools') #}
{#     - require: #}
{#       - pkg: {{ sls }}.pkg.smartmontools #}
{# endcall #}
