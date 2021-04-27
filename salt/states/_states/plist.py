# -*- coding: utf-8 -*-

import salt.utils.platform

__virtualname__ = 'plist'

def __virtual__():
    return __virtualname__ if salt.utils.platform.is_darwin() else False

def merge(name, value, **kwargs):
    ret = {'name': name, 'changes': {}, 'result': True, 'comment': ''}
    changes = {'old': {}, 'new': {}}

    # flatten values
    key_paths = list(_flatten_to_key_paths(value))

    # get old values
    existing_key_paths = [(key_path, __salt__['plist.get'](name, key_path)) for key_path, _ in key_paths]

    # find all changes
    changed_key_paths = []
    changed_existing_key_paths = []
    for (key_path, newVal), (_, oldVal) in zip(key_paths, existing_key_paths):
        if str(newVal) != str(oldVal):
            changed_key_paths.append((key_path, newVal))
            changed_existing_key_paths.append((key_path, oldVal))

    # just include differences
    if changed_key_paths:
        changes['new'] = ['.'.join(key_path) + ': ' + str(value) for key_path, value in changed_key_paths]
        changes['old'] = ['.'.join(key_path) + ': ' + str(value) for key_path, value in changed_existing_key_paths]

    # there are changes to be made
    if changes['new']:
        ret['changes'] = changes

        if __opts__['test']:
            ret['result'] = None
            ret['comment'] = 'would be merged'
        else:
            success = True
            for key_path, value in changed_key_paths:
                if not __salt__['plist.set'](name, key_path, value):
                    success = False
            ret['result'] = success

            if success:
                ret['comment'] = 'merged'
            else:
                ret['comment'] = 'failed merging'
    else:
        ret['comment'] = 'is already merged'

    return ret

def _flatten_to_key_paths(ctx, parent_keys=[]):
    for key, value in ctx.items():
        key_path = parent_keys + [key]
        if isinstance(value, dict):
            yield from _flatten_to_key_paths(value, parent_keys=key_path)
        else:
            yield key_path, value
