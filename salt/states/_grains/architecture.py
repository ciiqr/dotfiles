#!/usr/bin/env python

import logging
import platform

def main():
    arch_map = {
        'x86_64': 'amd64',
    }

    machine = platform.machine()
    architecture = arch_map.get(machine, machine)

    return {
        'architecture': architecture,
    }

