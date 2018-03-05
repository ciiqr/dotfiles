# -*- coding: utf-8 -*-

import logging
from string import strip, split
import salt.utils
import salt.exceptions
from salt.ext.six.moves import shlex_quote as _cmd_quote
from salt.ext.six import iteritems as _iteritems

log = logging.getLogger(__name__)

__func_alias__ = {
    'set_': 'set',
}

OSX_HOSTNAME_TYPES = [
    # Bonjour name ending in .local
    'LocalHostName',
    # Friendly name shown in System Preferences > Sharing
    'ComputerName',
    # The name recognized by the hostname command
    'HostName',
]

# TODO: this still isn't perfect for osx...
# TODO: testing has indicated this isn't perfect on windows either...


def get(**kwargs):
    platform = __salt__['platform.get_name']()
    if platform == 'osx':
        return _get_osx(**kwargs)
    elif platform == 'windows':
        return _get_windows(**kwargs)

    return _get_unix()


def set_(name, **kwargs):
    platform = __salt__['platform.get_name']()
    if platform == 'osx':
        return _set_osx(name, **kwargs)
    elif platform == 'windows':
        return _get_windows(**kwargs)

    return _set_unix(name, **kwargs)


def _get_osx(**kwargs):
    type_ = kwargs.get('type', 'HostName')
    if type_ not in OSX_HOSTNAME_TYPES:
        raise salt.exceptions.SaltInvocationError(
            'Invalid hostname type given: {0}'.format(type_)
        )

    cmd = 'scutil --get {0}'.format(_cmd_quote(type_))
    return __salt__['cmd.run'](cmd)


def _set_osx(name, **kwargs):
    for type_ in OSX_HOSTNAME_TYPES:
        result = _set_osx_of_type(type_, name)
        if result['retcode'] != 0:
            return False
    return True


def _set_osx_of_type(type_, name):
    cmd = 'scutil --set {0} {1}'.format(type_, _cmd_quote(name))
    return __salt__['cmd.run_all'](cmd)


def _get_windows():
    return __salt__['system.get_hostname']()


def _set_windows(name, **kwargs):
    hostname_res = __salt__['system.set_hostname'](name)


def _get_unix():
    return __salt__['network.get_hostname']()


def _set_unix(name, **kwargs):
    return __salt__['network.mod_hostname'](name)
