{{ sls }}.hostname:
  hostname.system:
    - name: {{ salt['pillar.get']('default:hostname', grains['id']) }}
