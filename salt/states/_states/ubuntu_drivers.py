# -*- coding: utf-8 -*-

import logging

log = logging.getLogger(__name__)

def installed(*args, **kwargs):
    output = __salt__['cmd.run']('ubuntu-drivers list').splitlines()
    kwargs['pkgs'] = output
    return __states__['pkg.installed'](*args, **kwargs)
