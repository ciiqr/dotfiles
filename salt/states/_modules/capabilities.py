# -*- coding: utf-8 -*-

import logging
import salt.utils
import os.path
from salt.ext.six.moves import shlex_quote as _cmd_quote

log = logging.getLogger(__name__)

__virtualname__ = 'capabilities'
__func_alias__ = {
    'set_': 'set',
}

def __virtual__():
    return __virtualname__ if salt.utils.which('getcap') else False


def get(name, **kwargs):
    realpath = os.path.realpath(name)
    cmd = 'getcap {}'.format(_cmd_quote(realpath))
    output = __salt__['cmd.run'](cmd).splitlines()

    if len(output) != 1:
        log.debug(output)
        return []

    prefix = '{} = '.format(realpath)
    return _removePrefix(output[0], prefix).split(',')


def set_(name, capabilities, **kwargs):
    capabilities_str = sanitize(capabilities, toString=True)

    realpath = os.path.realpath(name)
    cmd = 'setcap {} {}'.format(_cmd_quote(capabilities_str), _cmd_quote(realpath))
    result = __salt__['cmd.run_all'](cmd)

    log.debug(result)

    return result['retcode'] == 0


def areSame(caps1, caps2):
    caps1 = sanitize(caps1)
    caps2 = sanitize(caps2)

    return set(caps1) == set(caps2)


def sanitize(caps, toString=False):
    if toString and isinstance(caps, list):
        caps = ','.join(caps)
    elif not toString and not isinstance(caps, list):
        caps = caps.split(',')

    return caps


def _removePrefix(text, prefix):
    return text[len(prefix):] if text.startswith(prefix) else text
