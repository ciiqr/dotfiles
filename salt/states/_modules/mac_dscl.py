#!/usr/bin/env python

import logging
import os.path
from salt.ext.six.moves import shlex_quote as _cmd_quote

log = logging.getLogger(__name__)

def read(user, key, **kwargs):
    home = os.path.expanduser(f'~{user}')

    cmd = f'dscl . -read {_cmd_quote(home)} {_cmd_quote(key)}'
    output = __salt__['cmd.run'](cmd).splitlines()

    if len(output) != 1:
        log.debug(output)
        return ''

    prefix = f'{key}: '
    return _removePrefix(output[0], prefix)

def _removePrefix(text, prefix):
    return text[len(prefix):] if text.startswith(prefix) else text
