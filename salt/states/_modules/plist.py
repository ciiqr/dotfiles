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
        f'/usr/libexec/PlistBuddy -c {_cmd_quote(plist_buddy_command)} {_cmd_quote(name)}',
        ignore_retcode = True
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

    # Make sure parent key_path exists (else Set will fail)
    type_ = _plist_buddy_type(value)
    ensure_has_key_path(name, key_path, type_)

    plist_buddy_command = f'Set :{plist_buddy_key_path} {value}'
    result = __salt__['cmd.run_all'](
        f'/usr/libexec/PlistBuddy -c {_cmd_quote(plist_buddy_command)} {_cmd_quote(name)}'
    )

    log.debug(result)

    return result['retcode'] == 0

def _build_plist_buddy_key_path(key_path):
    return ':'.join(key_path)

def ensure_has_key_path(name, key_path, type_, **kwargs):
    current = []
    for key in key_path:
        current.append(key)

        if not has(name, current):
            current_type = type_ if len(current) == len(key_path) else 'dict'

            add(name, current, current_type)

def _plist_buddy_type(value):
    # NOTE: plisy buddy also supports date and data but I don't think there's a great way of setting these from yaml. Likely won't come up anyways.
    if isinstance(value, float):
        return 'real'
    elif isinstance(value, int):
        return 'integer'
    elif isinstance(value, bool):
        return 'bool'
    elif isinstance(value, str):
        return 'string'
    elif isinstance(value, list):
        return 'array'
    elif isinstance(value, dict):
        return 'dict'
    else:
        return 'string'

def has(name, key_path, **kwargs):
    plist_buddy_key_path = _build_plist_buddy_key_path(key_path)

    plist_buddy_command = f'Print :{plist_buddy_key_path}'
    result = __salt__['cmd.run_all'](
        f'/usr/libexec/PlistBuddy -c {_cmd_quote(plist_buddy_command)} {_cmd_quote(name)}',
        ignore_retcode = True
    )

    log.debug(result)

    return (result['retcode'] == 0)

def add(name, key_path, type_, **kwargs):
    plist_buddy_key_path = _build_plist_buddy_key_path(key_path)

    plist_buddy_command = f'Add :{plist_buddy_key_path} {type_}'
    result = __salt__['cmd.run_all'](
        f'/usr/libexec/PlistBuddy -c {_cmd_quote(plist_buddy_command)} {_cmd_quote(name)}'
    )

    log.debug(result)

    return (result['retcode'] == 0)
