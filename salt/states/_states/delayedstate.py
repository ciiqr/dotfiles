# -*- coding: utf-8 -*-

import logging
import salt.exceptions
from salt.ext.six.moves import shlex_quote as _cmd_quote
from salt.ext.six import iteritems as _iteritems

log = logging.getLogger(__name__)

# TODO: I'd like a more generic version of this (ie. to wrap any arbitrary state... delayedstate.wrap)
def file_managed(*args, **kwargs):
    context = kwargs.get('context', {})
    delayed_context = kwargs.pop('delayed_context', {})

    for key, method in _iteritems(delayed_context):
        value = None

        if 'result_of' in method:
            method_name = method['result_of']
            method_args = method.get('args', [])
            method_kwargs = method.get('kwargs', {})
            value = __salt__[method_name](*method_args, **method_kwargs)
        else:
            log.error('delayedstate unknown method: {0}'.format(method))

        context[key] = value

    kwargs['context'] = context
    return __states__['file.managed'](*args, **kwargs)
