#!/usr/bin/env python

import logging
log = logging.getLogger(__name__)

def state_exists(*args, **kwargs):
	return any(True for name in args if _exists('file_roots', name, **kwargs))

def pillar_exists(*args, **kwargs):
	return any(True for name in args if _exists('pillar_roots', name, **kwargs))

def _exists(type, name, **kwargs):
	env = __opts__.get('saltenv') or 'base'
	if env not in __opts__[type]:
		log.warning('saltenv "{0}": does not exist'.format(env))
		return False

	slash_name = name.replace('.', '/')

	# prefix relative path's with sls path
	if slash_name and slash_name[0] == '/':
		slspath = kwargs.get('slspath', '')
		slash_name = slspath + slash_name

	for root in __opts__[type][env]:
		base_path = '{0}/{1}'.format(root, slash_name)
		init_path = '{0}/init.sls'.format(base_path, slash_name)
		sls_path = '{0}.sls'.format(base_path, slash_name)

		if any(__salt__['file.file_exists'](path) for path in [init_path, sls_path]):
			return True

	return False
