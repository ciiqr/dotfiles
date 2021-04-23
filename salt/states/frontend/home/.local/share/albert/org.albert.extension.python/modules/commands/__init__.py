# -*- coding: utf-8 -*-

"""My custom commands"""

# EXAMPLES: https://github.com/albertlauncher/python

from albert import Item, ProcAction

__title__ = "Commands"
__version__ = "0.0.1"
__authors__ = ["ciiqr"]

# TODO: icon
# TODO: load from a directory structure?
commands = {
    # TODO: consider TermAction for alacritty stuff
    'SSH / Server-Data': ['alacritty', '-e', 'ssh', 'server-data'],
    'SSH / Server-Data': ['alacritty', '-e', 'ssh', 'server-data'],
    'SSH / Server-Data (Remote)': ['alacritty', '-e', 'ssh', 'remote-data'],
    'Toggle / Mount / Server-Data': ['toggle_mount', 'smb', 'server-data/data'],
    'Toggle / Mount / Server-Data (Remote)': ['toggle_mount', 'ssh', 'remote-data:/data/'],
    'XPointAndKill': ['/home/william/.scripts/XPointAndKill'],
}

def handleQuery(query):
    results = []

    # add all matching commands
    stripped = query.string.strip().lower().split()
    if stripped:
        for title, command in commands.items():
            # query is split on spaces and each part must be in the command title
            title_lower = title.lower()
            if all(strip in title_lower for strip in stripped):
                results.append(Item(
                    id=title,
                    text=title,
                    subtext=' '.join(command),
                    actions=[
                        ProcAction("Run", command),
                    ]
                ))

    return results
