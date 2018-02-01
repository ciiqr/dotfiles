{% from "macros/optional.sls" import optional_include with context %}

# TODO: change to dots if we're really going to use this
{{ optional_include(slspath ~ '/' ~ grains['platform']) }}
