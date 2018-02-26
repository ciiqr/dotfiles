#!/usr/bin/env python

def update_required_with_only_irrelevant_local_changes(name, target, user):
    env = __opts__.get('saltenv') or 'base'

    only_irrelevant_local_changes = not __salt__['git.diff'](target,
        'HEAD',
        git_opts='-c core.fileMode=false',
        user=user,
        password=None
    )

    local_rev = __salt__['git.revision'](
        target,
        user=user,
        password=None,
        ignore_retcode=True
    )

    remote_rev = __salt__['git.remote_refs'](
        name,
        heads=False,
        tags=False,
        user=user,
        password=None,
        identity=None,
        https_user=None,
        https_pass=None,
        ignore_retcode=False,
        saltenv=env
    )['HEAD']

    return only_irrelevant_local_changes and local_rev != remote_rev
