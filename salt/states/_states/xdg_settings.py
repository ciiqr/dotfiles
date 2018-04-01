# -*- coding: utf-8 -*-

import logging

log = logging.getLogger(__name__)

__virtualname__ = 'xdg_settings'

def __virtual__():
    if 'xdg_settings.set' in __salt__:
        return __virtualname__
    return (False, ('Cannot load the {0} module'.format(__virtualname__)))


def present(name, value, subprop=None, user=None, **kwargs):
    ret = {'name': name, 'changes': {}, 'result': True, 'comment': ''}

    if not __salt__['xdg_settings.check'](name, value, subprop, user):
        existing = __salt__['xdg_settings.get'](name, subprop, user)
        ret['changes'] = {'old': existing, 'new': value}

        if __opts__['test']:
            ret['result'] = None
        else:
            ret['result'] = __salt__['xdg_settings.set'](name, value, subprop, user)

    ret['comment'] = _comment(ret).format(_format_name(name, subprop), value)

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


def _format_name(name, subprop=None):
    if subprop is None:
        return name
    return '{}.{}'.format(name, subprop)
