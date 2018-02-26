{% import "macros/primary.sls" as primary with context %}

{{ sls }}.latest:
  git.latest:
    - name: git://github.com/robbyrussell/oh-my-zsh.git
    - target: {{ primary.home() }}/.oh-my-zsh
    - user: {{ primary.user() }}
    - force_reset: {{ salt['gitutils.update_required_with_only_irrelevant_local_changes'](
      'git://github.com/robbyrussell/oh-my-zsh.git',
      target = primary.home() ~ '/.oh-my-zsh',
      user = primary.user()
    ) }}

{{ sls }}.perms:
  file.directory:
    - name: {{ primary.home() }}/.oh-my-zsh
    - user: {{ primary.user() }}
    - group: {{ primary.group() }}
    - dir_mode: 700
    - file_mode: 600
    - recurse:
      - user
      - group
      - mode
    - require:
      - {{ sls }}.latest
