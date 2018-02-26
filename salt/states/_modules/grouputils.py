#!/usr/bin/env python

def groupNameById(gid):
    for group in __salt__['group.getent']():
        if group['gid'] == gid:
            return group['name']
    return None
