# -*- coding: utf-8 -*-

import logging
import salt.utils.path
from salt.ext.six.moves import shlex_quote as _cmd_quote

log = logging.getLogger(__name__)

__virtualname__ = 'xdg_settings'
__func_alias__ = {
    'set_': 'set',
}

def __virtual__():
    return __virtualname__ if salt.utils.path.which('xdg-settings') else False


def get(name, subprop = None, user = None, **kwargs):
    subpropParam = '' if subprop is None else _cmd_quote(subprop)
    cmd = 'xdg-settings get {} {}'.format(_cmd_quote(name), subpropParam)
    output = __salt__['cmd.run'](cmd, runas=user).splitlines()

    if len(output) != 1:
        log.debug(output)
        return None

    return output[0]


def check(name, value, subprop = None, user = None, **kwargs):
    subpropParam = '' if subprop is None else _cmd_quote(subprop)
    cmd = 'xdg-settings check {} {} {}'.format(_cmd_quote(name), subpropParam, _cmd_quote(value))
    output = __salt__['cmd.run'](cmd, runas=user).splitlines()

    if len(output) != 1:
        log.debug(output)
        return None

    return output[0] == 'yes'


def set_(name, value, subprop = None, user = None, **kwargs):
    subpropParam = '' if subprop is None else _cmd_quote(subprop)
    cmd = 'xdg-settings set {} {} {}'.format(_cmd_quote(name), subpropParam, _cmd_quote(value))
    result = __salt__['cmd.run_all'](cmd, runas=user)

    log.debug(result)

    return result['retcode'] == 0
