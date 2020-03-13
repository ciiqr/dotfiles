# all
{{ sls }}.standbydelay:
  pmset.present:
    - name: standbydelay
    - value: 1800

{{ sls }}.standby:
  pmset.present:
    - name: standby
    - value: true

{{ sls }}.disksleep:
  pmset.present:
    - name: disksleep
    - value: 10

{{ sls }}.lidwake:
  pmset.present:
    - name: lidwake
    - value: true

# battery
{{ sls }}.battery.displaysleep:
  pmset.present:
    - source: battery
    - name: displaysleep
    - value: 15

{{ sls }}.battery.sleep:
  pmset.present:
    - source: battery
    - name: sleep
    - value: 15

{{ sls }}.battery.autopoweroff:
  pmset.present:
    - source: battery
    - name: autopoweroff
    - value: true

{{ sls }}.battery.autopoweroffdelay:
  pmset.present:
    - source: battery
    - name: autopoweroffdelay
    - value: 14400

# ac
{{ sls }}.ac.displaysleep:
  pmset.present:
    - source: ac
    - name: displaysleep
    - value: 0

{{ sls }}.ac.sleep:
  pmset.present:
    - source: ac
    - name: sleep
    - value: 0

{{ sls }}.ac.autopoweroff:
  pmset.present:
    - source: ac
    - name: autopoweroff
    - value: false
