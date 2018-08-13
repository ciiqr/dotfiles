#!/usr/bin/env python

import yaml
import logging
import os.path
import salt.utils.files
import salt.syspaths

log = logging.getLogger(__name__)

def main():
    file = os.path.join(salt.syspaths.CONFIG_DIR, 'machines.yaml')
    grains = {}
    with salt.utils.files.fopen(file, 'rb') as fp:
        try:
            id_ = __opts__.get('id', '')
            machines = yaml.safe_load(fp.read()) or {}
            grains = machines.get(id_, {})
        except Exception:
            log.warning(
                "Failed loading grains from '{0}'! Skipping.".format(file)
            )
    return grains
