#!/usr/bin/env python

def get_repo_url(target, user):
    SSH_URL = 'git@github.com:ciiqr/awesome.git'
    HTTPS_URL = 'https://github.com/ciiqr/awesome.git'

    # if repo already configured with ssh
    if __salt__['file.directory_exists'](target) and __salt__['git.remote_get'](target)['push'] == SSH_URL:
        return SSH_URL

    # if github authenticated
    githubAuthenticatedCmd = 'ssh git@github.com 2>&1 | grep -q "successfully authenticated, but GitHub does not provide shell access"'
    retcode = __salt__['cmd.retcode'](githubAuthenticatedCmd, runas=user, python_shell=True, ignore_retcode=True)
    return SSH_URL if retcode == 0 else HTTPS_URL
