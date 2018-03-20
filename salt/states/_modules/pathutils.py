#!/usr/bin/env python

import os.path

def isLikeFile(path):
    return os.path.isfile(os.path.realpath(path))
