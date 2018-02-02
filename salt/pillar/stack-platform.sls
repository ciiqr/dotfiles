{% from "macros/optional.sls" import optional_pillar_stacks with context %}

{% set platform = __salt__['grains.get']('platform', '') %}
{{ optional_pillar_stacks(platform) }}
