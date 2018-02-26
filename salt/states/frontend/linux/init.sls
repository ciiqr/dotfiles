{% import "macros/dotfiles.sls" as dotfiles with context %}

{{ dotfiles.link_static() }}
