{% import "macros/primary.sls" as primary with context %}
{% import "macros/root.sls" as root with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/service.sls" as service with context %}

{% set server_data = pillar.get('server-data', {}) %}
{% set deluge = server_data.get('deluge', {}) %}

{% call pkg.all_installed(server_data) %}
  - acl
  - deluge-server
  - samba-server
  - nfs-server
  - minidlna
{% endcall %}

# TODO: can I specify these? do I care? --disabled-password --gecos "Deluge service"
{{ sls }}.deluge.user:
  user.present:
    - name: {{ deluge.user }}
    - system: true
    - fullname: 'Deluge service'
    - home: /srv/deluge
    - groups:
      - {{ deluge.group }}
    - remove_groups: True
    - require:
      - group: {{ sls }}.deluge.group

{{ sls }}.deluge.group:
  group.present:
    - name: {{ deluge.group }}
    - system: true

{{ sls }}.media_group:
  group.present:
    - name: {{ server_data.media_group }}
    - system: true
    - members: # TODO: might just make a pillar with user values and add this group so it doesn't have to be here
      - {{ primary.user() }}

# Deluge - Log files
{{ sls }}./var/log/deluged.log:
  file.managed:
    - name: /var/log/deluged.log
    - makedirs: true
    - user: {{ deluge.user }}
    - group: {{ deluge.group }}
    - mode: 644

{{ sls }}./var/log/deluge-web.log:
  file.managed:
    - name: /var/log/deluge-web.log
    - makedirs: true
    - user: {{ deluge.user }}
    - group: {{ deluge.group }}
    - mode: 644

# Deluge - Allow python (and as such, deluge) to use port 80
{% for cmd in ['python', 'python2', 'python3'] %}
  {% set path = salt['cmd.which'](cmd) %}
  {% if path is not none %}

{{ sls }}.{{ cmd }}.capabilities:
  capabilities.present:
    - name: {{ path }}
    - capabilities: cap_net_bind_service+ep

  {% endif %}
{% endfor %}

# Deluge - Service files
{{ sls }}./etc/systemd/system/deluged.service:
  file.managed:
    - name: /etc/systemd/system/deluged.service
    - source: salt://{{ slspath }}/files/deluge/deluged.service
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - onchanges_in:
      - module: {{ sls }}.systemctl_reload

{{ sls }}./etc/systemd/system/deluged-web.service:
  file.managed:
    - name: /etc/systemd/system/deluged-web.service
    - source: salt://{{ slspath }}/files/deluge/deluged-web.service
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - onchanges_in:
      - module: {{ sls }}.systemctl_reload

{{ sls }}.systemctl_reload:
  module.run:
    - name: service.systemctl_reload

# TODO: inside installer, salt is trying to use upstart service provider instead of systemd

{% call service.running('deluge-server', server_data) %}
    - require:
      - pkg: {{ sls }}.pkg.deluge-server
{% endcall %}

{% call service.running('deluge-web-server', server_data) %}
    - require:
      - pkg: {{ sls }}.pkg.deluge-server
{% endcall %}


# Deluge - Configs

# Generate auth file
{{ sls }}.~/.config/deluge/auth:
  file.managed:
    - name: {{ primary.home() }}/.config/deluge/auth
    - source: salt://{{ slspath }}/files/deluge/auth
    - makedirs: true
    - user: {{ deluge.user }}
    - group: {{ deluge.group }}
    - mode: 644
    - template: jinja
    - context:
        deluge_localclient_password: {{ salt['persistent_random.get_str']('deluge_localclient_password', length=20) }}
        passwd_username: {{ primary.user() }}
        deluge_user_password: {{ deluge.password }}

{% set deluge_web_pwd_salt = salt['persistent_random.get_str']('deluge_web_pwd_salt', length=20) %}
{% set deluge_web_pwd_sha1 = salt['random.hash'](deluge_web_pwd_salt ~ deluge.password, algorithm='sha1') %}
{{ sls }}.~/.config/deluge/web.conf:
  file.managed:
    - name: {{ primary.home() }}/.config/deluge/web.conf
    - source: salt://{{ slspath }}/files/deluge/web.conf
    - makedirs: true
    - user: {{ deluge.user }}
    - group: {{ deluge.group }}
    - mode: 644
    - template: jinja
    - context:
        pwd_sha1: {{ deluge_web_pwd_sha1 }}
        pwd_salt: {{ deluge_web_pwd_salt }}

{{ sls }}.~/.config/deluge/core.conf:
  file.managed:
    - name: {{ primary.home() }}/.config/deluge/core.conf
    - source: salt://{{ slspath }}/files/deluge/core.conf
    - makedirs: true
    - user: {{ deluge.user }}
    - group: {{ deluge.group }}
    - mode: 644

{{ sls }}.~/.config/deluge/label.conf:
  file.managed:
    - name: {{ primary.home() }}/.config/deluge/label.conf
    - source: salt://{{ slspath }}/files/deluge/label.conf
    - makedirs: true
    - user: {{ deluge.user }}
    - group: {{ deluge.group }}
    - mode: 644

{{ sls }}.~/.config/deluge/scheduler.conf:
  file.managed:
    - name: {{ primary.home() }}/.config/deluge/scheduler.conf
    - source: salt://{{ slspath }}/files/deluge/scheduler.conf
    - makedirs: true
    - user: {{ deluge.user }}
    - group: {{ deluge.group }}
    - mode: 644


# samba
{{ sls }}./etc/samba/smb.conf:
  file.managed:
    - name: /etc/samba/smb.conf
    - source: salt://{{ slspath }}/files/smb.conf
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - template: jinja
    - context:
        user: {{ primary.user() }}
        group: {{ server_data.media_group }}

# TODO: surely there's a better way...
{{ sls }}.samba.password:
  cmd.run:
    - name: echo "{{ server_data.samba.password }}\n{{ server_data.samba.password }}" | smbpasswd -a -s "{{ primary.user() }}"
    - onchanges:
      - file: {{ sls }}./etc/samba/smb.conf
    - require:
      - pkg: {{ sls }}.pkg.samba-server


# nfs
{{ sls }}./etc/exports:
  delayedstate.file_managed:
    - name: /etc/exports
    - source: salt://{{ slspath }}/files/exports
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - template: jinja
    - context:
        nfs_uid: {{ primary.uid() }}
    - delayed_context:
        nfs_gid:
          result_of: grouputils.groupIdByName
          args:
            - {{ server_data.media_group }}


# dlna
{{ sls }}./etc/default/minidlna:
  file.managed:
    - name: /etc/default/minidlna
    - source: salt://{{ slspath }}/files/default-minidlna
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - template: jinja
    - context:
        user: {{ primary.user() }}
        group: {{ server_data.media_group }}

{{ sls }}./etc/minidlna.conf:
  file.managed:
    - name: /etc/minidlna.conf
    - source: salt://{{ slspath }}/files/minidlna.conf
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - template: jinja
    - context:
        dlna_user_home: {{ primary.home() }}
