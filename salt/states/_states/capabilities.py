# -*- coding: utf-8 -*-

import logging

log = logging.getLogger(__name__)

__virtualname__ = 'capabilities'

def __virtual__():
    if 'capabilities.set' in __salt__:
        return __virtualname__
    return (False, ('Cannot load the {0} module'.format(__virtualname__)))


def present(name, capabilities, **kwargs):
    ret = {'name': name, 'changes': {}, 'result': True, 'comment': ''}

    capabilities_str = __salt__['capabilities.sanitize'](capabilities, toString=True)
    existing = __salt__['capabilities.get'](name)
    if not __salt__['capabilities.areSame'](capabilities, existing):
        ret['changes'] = {'old': existing, 'new': capabilities_str}

        if __opts__['test']:
            ret['result'] = None
        else:
            ret['result'] = __salt__['capabilities.set'](name, capabilities)

    ret['comment'] = _comment(ret).format(name, capabilities)

    return ret


def _comment(ret):
    if not ret['changes']:
        return '{0} is already set to {1}'
    elif __opts__['test']:
        return '{0} would be changed to {1}'
    elif ret['result']:
        return '{0} changed to {1}'
    else:
        return '{0} failed while changing to {1}'
