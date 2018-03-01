# -*- coding: utf-8 -*-

import logging
from string import strip, split
import salt.utils
import salt.exceptions
from salt.ext.six.moves import shlex_quote as _cmd_quote
from salt.ext.six import iteritems as _iteritems

log = logging.getLogger(__name__)

POWER_SOURCE_CUSTOM_HEADERS = {
    'battery': 'Battery Power:',
    'ac': 'AC Power:',
}

POWER_SWITCHES = {
    'battery': '-b',
    'ac': '-c',
    'all': '-a',
}

__virtualname__ = 'pmset'
__func_alias__ = {
    'set_': 'set',
    'list_': 'list',
}

def __virtual__():
    return __virtualname__ if salt.utils.is_darwin() else False


def list_():
    output = __salt__['cmd.run']('/usr/bin/pmset -g custom').splitlines()

    if len(output) == 0:
        return None

    settings = {}
    source = None

    for line in output:
        isHeader = False
        for power_source, header in _iteritems(POWER_SOURCE_CUSTOM_HEADERS):
            if line.startswith(header):
                isHeader = True
                source = power_source
                settings[source] = {}
                break

        if isHeader == False:
            kv = split(strip(line))
            if len(kv) == 2:
                settings[source][kv[0]] = kv[1]

    return settings


def get(name, source='all', **kwargs):
    all_settings = list_()

    if source == 'all':
        return {source: settings.get(name, None) for source, settings in _iteritems(all_settings)}
    else:
        return all_settings.get(source, {}).get(name, None)


def set_(name, value, source='all', **kwargs):
    if source not in POWER_SWITCHES:
        raise salt.exceptions.SaltInvocationError(
            'Invalid power source given: {}'.format(name)
        )

    if isinstance(value, bool):
        cmd_value = '1' if value else '0'
    else:
        cmd_value = value

    result = __salt__['cmd.run_all'](
        '/usr/bin/pmset {0} {1} {2}'.format(POWER_SWITCHES[source], name, value)
    )

    log.debug(result)

    return result['retcode'] == 0
