{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/primary.sls" as primary with context %}
{% import "macros/root.sls" as root with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% from "macros/common.sls" import role_includes, platform, roles with context %}

{% call optional.include() %}
  - .awesome
  {{ role_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}

{{ pkg.repo('sublime') }}
{{ pkg.repo('spotify') }}
{{ pkg.repo('awesome') }}
{{ pkg.repo('noobslab-icons') }}

{% call pkg.all_installed() %}
  # xorg
  - xorg
  - xorg-tools
  - libinput

  # terminals
  - xterm
  - rxvt

  # Awesome
  - awesome
  - picom
  - dmenu
  - rofi
  - albert

  # Lxdm
  - lxdm

  # Network Manager
  - network-manager

  # Redshift
  - redshift

  # Themes
  - lxappearance
  - gtk-theme-widget
  - gtk-theme-icon
  - gtk-theme-cursor

  # Sublime
  - sublime

  # Google Chrome
  - google-chrome

  # Firefox
  - firefox

  # Spotify
  - spotify

  # Deluge
  - deluge

  # 1Password
  - 1password

  # File viewers
  - gpicview
  - fbreader
  - evince
  - vlc
  - libreoffice
  - adobe-acrobat-reader

  # Mount Samba Shares
  - samba

  # Fonts
  - fonts

  # Pulse Audio
  - pulseaudio
  # TODO: Do I really need to: usermod -aG pulse,pulse-access "$passwd_username"
  # TODO: Consider installing rtkit

  # xdg open
  - xdg-open

  # Misc
  - scrot
  - imagemagick
  - speedcrunch
  - spacefm
  - gparted
  - gksu
  - gcolor2
  - baobab
  - ntfs
  - zenity
  - youtube-dl
  - gucharmap
  - leafpad
  - nethogs
  - rfkill
  - iftop
  - iotop
  - pinta
  - inotify
  - hardinfo
  - powertop
  - libnotify
  - bleachbit
  - arandr

  # TODO: Still undecided
  - seahorse

  - discord
{% endcall %}

# TODO: move this all to a sub-state?
{% if not platform in ['windows', 'osx'] %}

{{ dotfiles.link_static('/x11-home') }}

# TODO: figure out proper path for different platforms...
# TODO: void I guess it was: /etc/X11/xorg.conf.d/61-libinput-options.conf
# Configure libinput
{{ sls }}./usr/share/X11/xorg.conf.d/61-libinput-options.conf:
  file.managed:
    - name: /usr/share/X11/xorg.conf.d/61-libinput-options.conf
    - source: salt://{{ slspath }}/files/61-libinput-options.conf
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - require:
      - pkg: {{ sls }}.pkg.libinput

# TODO: implement
# ~/.icons/default/index.theme
#   # This file is written by LXAppearance. Do not edit.
#   [Icon Theme]
#   Name=Default
#   Comment=Default Cursor Theme
#   Inherits=oxy-obsidian-hc

# TODO: add group (or manage in user.present?...) not applicable for all platforms, need to customize
# For Network Manager access
{{ sls }}.network_manager_group:
  group.present:
    - name: netdev
    - system: true
    - members: # TODO: might just make a pillar with user values and add this group so it doesn't have to be here
      - {{ primary.user() }}

{{ sls }}.~/.Xresources:
  file.managed:
    - name: {{ primary.home() }}/.Xresources
    - source: salt://{{ slspath }}/files/.Xresources
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - mode: 600
    - template: jinja
    - context:
        hidpi: {{ 'hidpi' in roles }}

{% set gtk_theme = salt['pillar.get']('frontend:gtk:theme', {}) %}
{{ sls }}.~/.gtkrc-2.0:
  file.managed:
    - name: {{ primary.home() }}/.gtkrc-2.0
    - source: salt://{{ slspath }}/files/.gtkrc-2.0
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - mode: 600
    - template: jinja
    - context:
        user_home: {{ primary.home() }}
        widget_theme: {{ gtk_theme.get('widget', {}).get('name', '') }}
        icon_theme: {{ gtk_theme.get('icon', {}).get('name', '') }}
        cursor_theme: {{ gtk_theme.get('cursor', {}).get('name', '') }}

{{ sls }}.~/.config/gtk-3.0/settings.ini:
  file.managed:
    - name: {{ primary.home() }}/.config/gtk-3.0/settings.ini
    - source: salt://{{ slspath }}/files/gtk-3.0-settings.ini
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - mode: 600
    - makedirs: true
    - template: jinja
    - context:
        widget_theme: {{ gtk_theme.get('widget', {}).get('name', '') }}
        icon_theme: {{ gtk_theme.get('icon', {}).get('name', '') }}
        cursor_theme: {{ gtk_theme.get('cursor', {}).get('name', '') }}

{{ sls }}.~/.config/albert/albert.conf:
  file.managed:
    - name: {{ primary.home() }}/.config/albert/albert.conf
    - source: salt://{{ slspath }}/files/albert.conf
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - mode: 600
    - makedirs: true
    - template: jinja

{{ sls }}.~/.dmrc:
  file.managed:
    - name: {{ primary.home() }}/.dmrc
    - source: salt://{{ slspath }}/files/.dmrc
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - mode: 600
    - template: jinja
    - context:
        user_home: {{ primary.home() }}


# pa-server
{{ sls }}.~/.config/systemd/user/pa-server.service:
  file.managed:
    - name: {{ primary.home() }}/.config/systemd/user/pa-server.service
    - source: salt://{{ slspath }}/files/pa-server.service
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - mode: 600
    - makedirs: true
    - template: jinja
    - context:
        user_home: {{ primary.home() }}

# TODO:
# # pa-server
# install python-pip python-wheel libpython-all-dev python-dbus
# pip install --user procname

# TODO: unfortunately the salt systemd module doesn't support --user
# ? systemctl --user daemon-reload
# systemctl --user enable pa-server.service

# TODO: a bunch of these aren't applicable on windows at very least

# Spacefm
{{ sls }}./etc/spacefm/{{ primary.user() }}-as-root:
  file.managed:
    - name: /etc/spacefm/{{ primary.user() }}-as-root
    - source: salt://{{ slspath }}/files/spacefm-as-root
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644

# lxdm
{{ sls }}./etc/lxdm/lxdm.conf:
  file.managed:
    - name: /etc/lxdm/lxdm.conf
    - source: salt://{{ slspath }}/files/lxdm.conf
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - template: jinja
    - context:
        {% if 'hidpi' in roles %}
        x11_options: -dpi 192
        {% endif %}

# logind.conf
{{ sls }}./etc/systemd/logind.conf:
  file.managed:
    - name: /etc/systemd/logind.conf
    - source: salt://{{ slspath }}/files/logind.conf
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644

# dbus user services
{{ sls }}./etc/systemd/system/user@.service.d/dbus.conf:
  file.managed:
    - name: /etc/systemd/system/user@.service.d/dbus.conf
    - source: salt://{{ slspath }}/files/systemd-user@.service.d-dbus.conf
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644

# directories
{{ sls }}.~/Downloads:
  file.directory:
    - name: {{ primary.home() }}/Downloads
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - mode: 700

{% endif %}
