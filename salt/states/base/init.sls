{% import "macros/primary.sls" as primary with context %}
{% import "macros/root.sls" as root with context %}

# Password less sudo
{{ sls }}./etc/sudoers.d/user-{{ primary.user() }}:
  file.managed:
    - name: /etc/sudoers.d/user-{{ primary.user() }}
    - source: salt://{{ slspath }}/files/sudoers-user
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 440
    - check_cmd: /usr/sbin/visudo -c -f
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
    - check_cmd: /usr/sbin/visudo -c -f
    - template: jinja
    - context:
        user: {{ primary.user() }}
{% endif %}

# default ssh key
{{ sls }}.ssh.key:
  cmd.run:
    - name: ssh-keygen -t rsa -b 4096 -o -N "" -f ~/.ssh/id_rsa
    - runas: {{ primary.user() }}
    - unless: test -f ~/.ssh/id_rsa
