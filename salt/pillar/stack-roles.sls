{% from "macros/optional.sls" import optional_pillar_stacks with context %}

{%- for role in __grains__['roles'] %}
{{ optional_pillar_stacks(role) }}
{%- endfor %}
