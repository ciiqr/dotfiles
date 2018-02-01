#!/usr/bin/env python

# import logging
# log = logging.getLogger(__name__)

def state_exists(name):
	return _exists('file_roots', name)

def pillar_exists(name):
	return _exists('pillar_roots', name)

# TODO: maybe don't have separate functions?
def any_state_exists(*args):
	return any(True for name in args if state_exists(name))

def any_pillar_exists(*args):
	return any(True for name in args if pillar_exists(name))


def _exists(type, name):
	# TODO: saltenv is None in pillars... is there anything reasonable to do? (maybe just look though all, since all should me merged anyways?)
	# TODO: Would also be good to support multi-level sls_paths (with dots though, not slashes)
	# TODO: support relative paths via tpldir

	env = __opts__.get('saltenv') or 'base'
	if env not in __opts__[type]:
		return False

	for root in __opts__[type][env]:
		base_path = '{0}/{1}'.format(root, name)
		init_path = '{0}/init.sls'.format(base_path, name)
		sls_path = '{0}.sls'.format(base_path, name)

		if any(__salt__['file.file_exists'](path) for path in [init_path, sls_path]):
			return True

	return False
