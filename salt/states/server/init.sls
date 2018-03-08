{% from slspath + "/map.jinja" import server with context %}
{% import "macros/optional.sls" as optional with context %}
{% import "macros/dotfiles.sls" as dotfiles with context %}
{% import "macros/pkg.sls" as pkg with context %}
{% from "macros/common.sls" import platform with context %}

{% call optional.include() %}
  - private.{{ sls }}
  - .{{ platform }}
  - private.{{ sls }}.{{ platform }}
{%- endcall %}

{{ dotfiles.link_static() }}

{% call pkg.all_installed(server) %}
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
    - user: root
    - group: root
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
