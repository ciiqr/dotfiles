
{{ sls }}.standbydelay:
  pmset.present:
    - name: standbydelay
    - value: 1800
