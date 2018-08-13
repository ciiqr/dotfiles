# -*- coding: utf-8 -*-

import logging
import salt.utils.platform
from salt.ext.six import iteritems as _iteritems

log = logging.getLogger(__name__)

__virtualname__ = 'pmset'

def __virtual__():
    return __virtualname__ if salt.utils.platform.is_darwin() else False

def present(name, value, source='all', **kwargs):
    ret = {'name': name, 'changes': {}, 'result': True, 'comment': ''}
    changes = {'old': {}, 'new': {}}

    if isinstance(value, bool):
        raw_value = '1' if value else '0'
    else:
        raw_value = str(value)

    existing_value = __salt__['pmset.get'](name, source=source)

    # find all changes
    if source == 'all':
        for exist_source, exist_value in _iteritems(existing_value):
            if raw_value != exist_value:
                changes['old'][exist_source] = exist_value
                changes['new'][exist_source] = raw_value
    else:
        if raw_value != existing_value:
            changes['old'][source] = existing_value
            changes['new'][source] = raw_value

    # there are changes to be made
    if changes['new']:
        ret['changes'] = changes

        if __opts__['test']:
            ret['result'] = None
            ret['comment'] = '{0} would be changed to {1} for {2}'.format(name, value, source)
        else:
            success = __salt__['pmset.set'](name, value, source=source)
            ret['result'] = success

            if success:
                ret['comment'] = '{0} changed to {1} for {2}'.format(name, value, source)
            else:
                ret['comment'] = 'failed changing {0} to {1} for {2}'.format(name, value, source)
    else:
        ret['comment'] = '{0} is already set to {1} for {2}'.format(name, value, source)

    return ret
