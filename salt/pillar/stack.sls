{% import "macros/optional.sls" as optional with context %}

default/*.sls
private/default/*.sls

{% set platform = __salt__['grains.get']('platform', '') %}
{{ optional.pillar_stacks(platform, 'private/' ~ platform) }}

{%- for role in __grains__['roles'] %}
{{ optional.pillar_stacks(role, 'private/' ~ role) }}
{%- endfor %}
