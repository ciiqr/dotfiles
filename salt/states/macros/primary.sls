{% macro user() -%}
  {{ grains['primaryUser'] }}
{%- endmacro %}

{% macro home() -%}
  {{ salt['user.info'](grains['primaryUser'])['home'] }}
{%- endmacro %}

# NOTE: primaryUserGroup can be set as needed with something like: salt-call grains.set primaryUserGroup 452276397 --out quiet
{% macro group() -%}
  {%- if 'primaryUserGroup' in grains -%}
  {{ grains['primaryUserGroup'] }}
  {%- elif 'user.primary_group' in salt -%}
  {{ salt['user.primary_group'](grains['primaryUser']) or grains['primaryUser'] }}
  {%- else -%}
  {{ grains['primaryUser'] }}
  {%- endif -%}
{%- endmacro %}

{% macro uid() -%}
  {{ salt['user.info'](grains['primaryUser'])['uid'] }}
{%- endmacro %}

# TODO: the path should also be dynamic
{% macro shell() -%}
  {%- if salt['pillar.get']('base:packages:zsh') or salt['cmd.which']('zsh') -%}
    /bin/zsh
  {%- elif salt['pillar.get']('base:packages:bash') or salt['cmd.which']('bash') -%}
    /bin/bash
  {%- endif -%}
{%- endmacro %}
