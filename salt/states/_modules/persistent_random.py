# -*- coding: utf-8 -*-

import logging
import os
import salt.utils
import salt.syspaths
from salt.ext.six.moves import shlex_quote as _cmd_quote

log = logging.getLogger(__name__)

__virtualname__ = 'persistent_random'

def __virtual__():
    return __virtualname__ if 'random.get_str' in __salt__ else False


def get_str(name, length=20):
    path = get_path('get_str', name)
    if os.path.exists(path):
        with open(path, 'r') as f:
            out = f.read()
    else:
        out = __salt__['random.get_str'](length=length)

        directory = os.path.dirname(path)
        if not os.path.exists(directory):
            os.makedirs(directory, 504) # octal 0770

        with open(path, 'w') as f:
            f.write(out)

    return out


def get_path(func, name):
    return os.path.join(salt.syspaths.CONFIG_DIR, 'config', 'cache', __virtualname__, func, name)
