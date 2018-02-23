
{{ sls }}.service:
  cmd.run:
    - name: launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
    - unless: launchctl list com.apple.locate

{{ sls }}.updatedb:
  cmd.run:
    - name: /usr/libexec/locate.updatedb
    - env:
      - PATH: /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin # TODO: this fixes issue with having g* utils on path... but maybe I should stop using those... or at least make the ones I really like aliases...
    - creates: /var/db/locate.database

{{ sls }}.bin.updatedb:
  file.symlink:
    - name: /usr/local/bin/updatedb
    - target: /usr/libexec/locate.updatedb
