{% import "macros/pkg.sls" as pkg with context %}
{% import "macros/primary.sls" as primary with context %}

# packages
{{ sls }}.pkg.albert:
  cmd.run:
    - name: yay -S --noconfirm albert
    - runas: {{ primary.user() }}
    - unless: yay -Qi albert

# services

# network
{{ sls }}.service.NetworkManager:
  service.running:
    - name: NetworkManager
