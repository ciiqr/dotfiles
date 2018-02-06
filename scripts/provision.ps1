
$ErrorActionPreference = "Stop"

# run salt highstate
salt-call saltutil.sync_all
salt-call --retcode-passthrough --state-verbose=False -l warning state.apply

# TODO: unfortunately salt doesn't support the idea of 'pkg.latest' with choco... (I should write my own, but for now, this is fine)
choco upgrade all -y
