# -*- coding: utf-8 -*-

import logging

log = logging.getLogger(__name__)

__virtualname__ = 'xdg_mime'

def __virtual__():
    if 'xdg_mime.set' in __salt__:
        return __virtualname__
    return (False, ('Cannot load the {0} module'.format(__virtualname__)))


def present(name, value, **kwargs):
    ret = {'name': name, 'changes': {}, 'result': True, 'comment': ''}

    existing = __salt__['xdg_mime.get'](name)
    if value != existing:
        ret['changes'] = {'old': existing, 'new': value}

        if __opts__['test']:
            ret['result'] = None
        else:
            ret['result'] = __salt__['xdg_mime.set'](name, value)

    ret['comment'] = _comment(ret).format(name, value)

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
