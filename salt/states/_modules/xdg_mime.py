# -*- coding: utf-8 -*-

import logging
import salt.utils
from salt.ext.six.moves import shlex_quote as _cmd_quote

log = logging.getLogger(__name__)

__virtualname__ = 'xdg_mime'
__func_alias__ = {
    'set_': 'set',
}

def __virtual__():
    return __virtualname__ if salt.utils.which('xdg-mime') else False


def get(name, user=None, **kwargs):
    cmd = 'xdg-mime query default {}'.format(_cmd_quote(name))
    output = __salt__['cmd.run'](cmd, runas=user).splitlines()

    if len(output) != 1:
        log.debug(output)
        return None

    return output[0]


def set_(name, value, user=None, **kwargs):
    cmd = 'xdg-mime default {} {}'.format(_cmd_quote(value), _cmd_quote(name))
    result = __salt__['cmd.run_all'](cmd, runas=user)

    log.debug(result)

    return result['retcode'] == 0
