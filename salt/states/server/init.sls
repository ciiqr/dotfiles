{% from slspath + "/map.jinja" import server with context %}
{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/root.sls" as root with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/service.sls" as service with context %}
{% from "macros/common.sls" import role_includes with context %}

{% call optional.include() %}
  {{ role_includes() }}
{%- endcall %}

{{ dotfiles.link_static() }}

{% call pkg.all_installed() %}
  - ssh-server
  - ddclient
{% endcall %}

# TODO: Change sshd configuration
# TODO: include the full sshd_config in config
# TODO: consider changing port like previously...: Port 57251
# TODO: Consider: enable only internal network by password
# PasswordAuthentication no
# ChallengeResponseAuthentication no
# Match Address 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
#     PasswordAuthentication yes


# TODO: do I even need this with the config set? just need to make sure config is dependent on pkg
# TODO: likely need to set these up before installing ddclient (with dependencies on the actual package). Only if os == 'Debian' though...
# ddclient ddclient/run_daemon boolean true
# ddclient ddclient/daemon_interval string 3600

{{ sls }}./etc/ddclient.conf:
  file.managed:
    - name: /etc/ddclient.conf
    - source: salt://{{ slspath }}/files/ddclient.conf
    - makedirs: true
    - user: {{ root.user() }}
    - group: {{ root.group() }}
    - mode: 644
    - template: jinja
    - context:
        ddclient: {{ server.ddclient }}


# TODO: Install: fail2ban
# https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-14-04

# TODO: Install: logrotate
# https://www.digitalocean.com/community/tutorials/how-to-manage-log-files-with-logrotate-on-ubuntu-12-10

# TODO: Install ufw
# https://www.digitalocean.com/community/tutorials/additional-recommended-steps-for-new-ubuntu-14-04-servers#configuring-a-basic-firewall

# services
{% call service.running('ssh-server', server) %}
    - require:
      - pkg: {{ sls }}.pkg.ssh-server
{% endcall %}

{% call service.running('ddclient', server) %}
    - require:
      - pkg: {{ sls }}.pkg.ddclient
{% endcall %}
