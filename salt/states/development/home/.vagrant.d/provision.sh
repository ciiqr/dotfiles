#!/usr/bin/env bash

# TODO: Figure out if we can prevent this running in a windows guest
# TODO: need to try switching to salt-ssh to install in vagrant... https://superuser.com/a/710739

vagrant_user()
{
    # Find the first of these users that exists
    for user in vagrant ubuntu root; do
        if grep -q '^'"$user"':' /etc/passwd; then
            echo "$user"
            break
        fi
    done
}

# Make sure we have config
[[ ! -d /config ]] && exit 0

# TODO: gitfs provider support (here or in bootstrap... ie. https://github.com/saltstack-formulas/salt-formula/blob/master/salt/gitfs/pygit2.sls)

# user
declare user=`vagrant_user`
if [[ -z "$user" ]]; then
    echo "couldn't find user"
    exit 0
fi

# install config
/config/scripts/install --machine vagrant --primaryUser "$user"
