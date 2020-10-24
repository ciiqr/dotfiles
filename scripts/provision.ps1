$ErrorActionPreference = "Stop"

# run salt highstate
salt-call saltutil.sync_all
salt-call --retcode-passthrough --state-verbose=False -l warning state.apply @Args
