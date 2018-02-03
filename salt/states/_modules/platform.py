#!/usr/bin/env python

try:
    import salt.utils.platform as _platform
except ImportError:
    import salt.utils as _platform

def get_name(**kwargs):
    if _platform.is_windows():
        return 'windows'
    elif _platform.is_darwin():
        return 'osx'
    elif _platform.is_linux():
        return 'linux'
    return ''
