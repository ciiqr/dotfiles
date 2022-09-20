{% import "macros/primary.sls" as primary with context %}
{% import "macros/pkg.sls" as pkg with context %}

{% call pkg.all_installed() %}
  - duti
{% endcall %}

# TODO: make a proper module
# TODO: get id from app name & use app name instead? (although, then we'd need to do this after apps are installed)
# $ osascript -e 'id of app "Sublime Text"'

{{ sls }}.default-program.md:
  cmd.run:
    - name: duti -s com.microsoft.VSCode .md all
    - runas: {{ primary.user() }}
    - unless: duti -x md | tail -1 | grep -q '^com.microsoft.VSCode$'

{{ sls }}.default-program.sh:
  cmd.run:
    - name: duti -s com.microsoft.VSCode .sh all
    - runas: {{ primary.user() }}
    - unless: duti -x sh | tail -1 | grep -q '^com.microsoft.VSCode$'

{{ sls }}.default-program.todo:
  cmd.run:
    - name: duti -s com.microsoft.VSCode .todo all
    - runas: {{ primary.user() }}
    - unless: duti -x todo | tail -1 | grep -q '^com.microsoft.VSCode$'

{{ sls }}.default-program.txt:
  cmd.run:
    - name: duti -s com.microsoft.VSCode .txt all
    - runas: {{ primary.user() }}
    - unless: duti -x txt | tail -1 | grep -q '^com.microsoft.VSCode$'
