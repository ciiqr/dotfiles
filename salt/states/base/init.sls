{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/pkg.sls" as pkg with context %}
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

  # TODO: move... to default.Debian OR default.Ubuntu along with pillars
  # Apt thugs
  - apt-tools
  - debconf-utils

  # Zsh
  - zsh

  # TODO: this is required in base if we're going to use git install omz, but it's not really required otherwise... maybe doesn't matter
  - git
{% endcall %}


# TODO: Update apt-file (creates /var/cache/apt/apt-file/*)
# TODO: sensors-detect --auto

# TODO: Switch to zsh, except, maybe that's should be handled by a user.present statement...
# sudo chsh -s /bin/zsh "$passwd_username"


# TODO: need paths for these...
# 'FreeBSD': {
#   'configpath': '/usr/local/etc',
#   'includedir': '/usr/local/etc/sudoers.d',
#   'execprefix': '/usr/local/sbin',
# }

{% if base.get('packages', {}).get('zsh') %}

# Make sure zsh works properly... sigh ubuntu
# NOTE: this may not be required on all platforms, but unless it breaks something, I'll leave it here.
{% set zsh_etc_path = pillar.get('base:zsh_etc_path', '/etc/zsh') %}
{{ sls }}.{{ zsh_etc_path }}/zprofile:
  file.managed:
    - name: {{ zsh_etc_path }}/zprofile
    - source: salt://{{ slspath }}/files/zprofile
    - makedirs: true
    - user: root
    - group: root
    - mode: 644

{% endif %}

{% if not platform in ['windows'] %}

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
# TODO: probably want to: sysctl --system on changes
{{ sls }}./etc/sysctl.d/100-sysctl.conf:
  file.managed:
    - name: /etc/sysctl.d/100-sysctl.conf
    - source: salt://{{ slspath }}/files/100-sysctl.conf
    - makedirs: true
    - user: root
    - group: root
    - mode: 644

{% endif %}

# TODO: implement
# # Updatedb
# ADDITIONAL_PRUNE_PATHS="$user_home/.cache $user_home/.config/google-chrome $user_home/.mozilla /etc/mono/certstore/certs /etc/ssl/certs"
# # TODO: Replace with replace_or_append (need to make sure I can use replacements... well I can at least grab the data I want first then find/replace)
# sed -i 's@[# ]*PRUNEPATHS="\(.*\)"@PRUNEPATHS="\1 '"$ADDITIONAL_PRUNE_PATHS"'"@;s@[# ]*PRUNENAMES="\(.*\)"@PRUNENAMES="\1"@' /etc/updatedb.conf

# TODO: implement
# # Enable services
# systemctl enable haveged smartd
