# -*- coding: utf-8 -*-

import logging
import salt.utils
from salt.ext.six import iteritems as _iteritems

log = logging.getLogger(__name__)

__virtualname__ = 'hostname'

def __virtual__():
    if 'hostname.set' in __salt__:
        return __virtualname__
    return (False, ('Cannot load the {0} module: '.format(__virtualname__)))

def system(name, **kwargs):
    ret = {'name': name, 'changes': {}, 'result': True, 'comment': ''}
    changes = {'old': {}, 'new': {}}

    existing = __salt__['hostname.get']()
    # TODO: this still isn't perfect for osx...

    # find all changes
    if name != existing:
        changes['old'] = existing
        changes['new'] = name

    # there are changes to be made
    if changes['new']:
        ret['changes'] = changes

        if __opts__['test']:
            ret['result'] = None
            ret['comment'] = 'hostname would be changed to {0}'.format(name)
        else:
            success = __salt__['hostname.set'](name)
            ret['result'] = success

            if success:
                ret['comment'] = 'hostname changed to {0}'.format(name)
            else:
                ret['comment'] = 'failed changing hostname to {0}'.format(name)
    else:
        ret['comment'] = 'hostname is already set to {0}'.format(name)

    return ret
