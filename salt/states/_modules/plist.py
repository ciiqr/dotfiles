# -*- coding: utf-8 -*-

import logging
import salt.utils.platform
from salt.ext.six.moves import shlex_quote as _cmd_quote
from salt.ext.six import iteritems as _iteritems

log = logging.getLogger(__name__)

__virtualname__ = 'plist'
__func_alias__ = {
    'set_': 'set',
}

def __virtual__():
    return __virtualname__ if salt.utils.platform.is_darwin() else False

def get(name, key_path, **kwargs):
    plist_buddy_key_path = _build_plist_buddy_key_path(key_path)

    plist_buddy_command = f'Print :{plist_buddy_key_path}'
    result = __salt__['cmd.run_all'](
        f'/usr/libexec/PlistBuddy -c {_cmd_quote(plist_buddy_command)} {_cmd_quote(name)}'
    )

    log.debug(result)

    return _normalize(result['stdout'])

def _normalize(value):
    # NOTE: dumb, but this is good enough for my purposes
    try:
        float_value = float(value)
        int_value = int(float_value)

        if int_value == float_value:
            return int_value

        return float_value
    except ValueError as e:
        return value

def set_(name, key_path, value, **kwargs):
    plist_buddy_key_path = _build_plist_buddy_key_path(key_path)

    plist_buddy_command = f'Set :{plist_buddy_key_path} {value}'
    result = __salt__['cmd.run_all'](
        f'/usr/libexec/PlistBuddy -c {_cmd_quote(plist_buddy_command)} {_cmd_quote(name)}'
    )

    log.debug(result)

    return result['retcode'] == 0

def _build_plist_buddy_key_path(key_path):
    return ':'.join(key_path)
