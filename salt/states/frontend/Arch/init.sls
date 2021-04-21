{% import "macros/pkg.sls" as pkg with context %}

# network
{{ sls }}.service.NetworkManager:
  service.running:
    - name: NetworkManager
