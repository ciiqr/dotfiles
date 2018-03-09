{% import "macros/primary.sls" as primary with context %}
{% import "macros/pkg.sls" as pkg with context %}

{% set server_data = pillar.get('server-data', {}) %}

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
    - name: {{ server_data.deluge.user }}
    - system: true
    - fullname: 'Deluge service'
    - home: /srv/deluge
    - groups:
      - {{ server_data.deluge.group }}
    - remove_groups: True
    - require:
      - group: {{ sls }}.deluge.group

{{ sls }}.deluge.group:
  group.present:
    - name: {{ server_data.deluge.group }}
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
    - user: {{ server_data.deluge.user }}
    - group: {{ server_data.deluge.group }}
    - mode: 644

{{ sls }}./var/log/deluge-web.log:
  file.managed:
    - name: /var/log/deluge-web.log
    - makedirs: true
    - user: {{ server_data.deluge.user }}
    - group: {{ server_data.deluge.group }}
    - mode: 644

# Deluge - Allow python (and as such, deluge) to use port 80
{% for cmd in ['python', 'python2', 'python3'] %}

{% set path = salt['cmd.which'](cmd) %}
# TODO: need a state for this
# setcap 'cap_net_bind_service=+ep' {{ path }}

{% endfor %}

# Deluge - Service files
{{ sls }}./etc/systemd/system/deluged.service:
  file.managed:
    - name: /etc/systemd/system/deluged.service
    - source: salt://{{ slspath }}/files/deluged.service
    - makedirs: true
    - user: root
    - group: root
    - mode: 644

{{ sls }}./etc/systemd/system/deluged-web.service:
  file.managed:
    - name: /etc/systemd/system/deluged-web.service
    - source: salt://{{ slspath }}/files/deluged-web.service
    - makedirs: true
    - user: root
    - group: root
    - mode: 644

# TODO:
# systemctl enable deluged deluged-web

# Deluge - Configs
su -s /bin/bash --login deluge <<EOF

# TODO: implement
# # deluged (Based on http://www.havetheknowhow.com/Install-the-software/Install-Deluge-Headless.html)
# # TODO: maybe I should check for sha1sum, then openssl (TODO: Create a function for it...)
# deluge_password="${priv_conf[deluge_password]}"
# deluge_localclient_password="`openssl rand -hex 20`"
# deluge_user_password="$deluge_password"
# deluge_web_pwd_salt="`openssl rand -hex 20`"
# deluge_web_pwd_sha1="`openssl sha1 <(echo -n "${deluge_web_pwd_salt}${deluge_password}")`"
# deluge_web_pwd_sha1="${deluge_web_pwd_sha1#*= }"

# Generate auth file
{{ sls }}.~/.config/deluge/auth:
  file.managed:
    - name: {{ primary.home() }}/.config/deluge/auth
    - source: salt://{{ slspath }}/files/deluge/auth
    - makedirs: true
    - user: {{ server_data.deluge.user }}
    - group: {{ server_data.deluge.group }}
    - mode: 644
    - template: jinja
    - context:
        deluge_localclient_password: 'TODO: implement'
        passwd_username: 'TODO: implement'
        deluge_user_password: 'TODO: implement'

{{ sls }}.~/.config/deluge/web.conf:
  file.managed:
    - name: {{ primary.home() }}/.config/deluge/web.conf
    - source: salt://{{ slspath }}/files/deluge/web.conf
    - makedirs: true
    - user: {{ server_data.deluge.user }}
    - group: {{ server_data.deluge.group }}
    - mode: 644
    - template: jinja
    - context:
        pwd_sha1: 'TODO: deluge_web_pwd_sha1'
        pwd_salt: 'TODO: deluge_web_pwd_salt'

{{ sls }}.~/.config/deluge/core.conf:
  file.managed:
    - name: {{ primary.home() }}/.config/deluge/core.conf
    - source: salt://{{ slspath }}/files/deluge/core.conf
    - makedirs: true
    - user: {{ server_data.deluge.user }}
    - group: {{ server_data.deluge.group }}
    - mode: 644

{{ sls }}.~/.config/deluge/label.conf:
  file.managed:
    - name: {{ primary.home() }}/.config/deluge/label.conf
    - source: salt://{{ slspath }}/files/deluge/label.conf
    - makedirs: true
    - user: {{ server_data.deluge.user }}
    - group: {{ server_data.deluge.group }}
    - mode: 644

{{ sls }}.~/.config/deluge/scheduler.conf:
  file.managed:
    - name: {{ primary.home() }}/.config/deluge/scheduler.conf
    - source: salt://{{ slspath }}/files/deluge/scheduler.conf
    - makedirs: true
    - user: {{ server_data.deluge.user }}
    - group: {{ server_data.deluge.group }}
    - mode: 644


# samba
{{ sls }}./etc/samba/smb.conf:
  file.managed:
    - name: /etc/samba/smb.conf
    - source: salt://{{ slspath }}/files/smb.conf
    - makedirs: true
    - user: root
    - group: root
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
  file.managed:
    - name: /etc/exports
    - source: salt://{{ slspath }}/files/exports
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        # TODO: how?... do I get this if these things won't exist till after some other state have run...
          # TODO: at least in this case I could specify the uid/gid... (if it doesn't exist already)
        # nfs_uid="`id -u "$passwd_username"`"
        # nfs_gid="`getent group "$common_group" | cut -d: -f3`"
        nfs_uid: {{ primary.uid() }}
        nfs_gid: {{ TODO: media gid }}


# dlna
{{ sls }}./etc/default/minidlna:
  file.managed:
    - name: /etc/default/minidlna
    - source: salt://{{ slspath }}/files/default-minidlna
    - makedirs: true
    - user: root
    - group: root
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
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        dlna_user_home: {{ primary.home() }}
