{% import "macros/optional.sls" as optional with context %}
{% set platform = __salt__['grains.get']('platform', '') %}
{% set os_family = __salt__['grains.get']('os_family', '') %}
{% set os = __salt__['grains.get']('os', '') %}
{% set roles = __salt__['grains.get']('roles', []) %}

default/*.sls
private/default/*.sls

{{ optional.pillar_stacks(platform, 'private/' ~ platform) }}

{{ optional.pillar_stacks(os_family, 'private/' ~ os_family) }}

{% if os != os_family %}
{{ optional.pillar_stacks(os, 'private/' ~ os) }}
{% endif %}

{%- for role in roles %}
{{ optional.pillar_stacks(role, 'private/' ~ role) }}
{%- endfor %}
