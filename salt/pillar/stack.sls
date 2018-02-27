{% from "macros/optional.sls" import optional_pillar_stacks with context %}

default/*.sls
private/default/*.sls

{% set platform = __salt__['grains.get']('platform', '') %}
{{ optional_pillar_stacks(platform, 'private/' ~ platform) }}

{%- for role in __grains__['roles'] %}
{{ optional_pillar_stacks(role, 'private/' ~ role) }}
{%- endfor %}
