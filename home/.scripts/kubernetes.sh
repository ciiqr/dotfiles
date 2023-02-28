#!/usr/bin/env bash

set -e

. ~/.scripts/lib/output.sh

kubernetes::run() {
    if [[ "$#" -lt 1 ]]; then
        echo 'usage: ~/.scripts/kubernetes.sh run <image> [<kubectl-options-or-commands>...]' 1>&2
        return 1
    fi

    declare image="$1"
    declare -a args=()
    declare has_command='false'

    # TODO: surely there's a less messy way of doing all this
    # ~/.scripts/kubernetes.sh run redis
    # ~/.scripts/kubernetes.sh run redis sh
    # ~/.scripts/kubernetes.sh run redis -- sh
    # ~/.scripts/kubernetes.sh run redis -n istio-system
    # ~/.scripts/kubernetes.sh run redis -n istio-system sh # expected to break
    # ~/.scripts/kubernetes.sh run redis -n istio-system -- sh
    if [[ "$#" -ge 2 && "$2" != '-'* ]]; then
        # has a command first: at least one arg after image, and it's not an option
        # ie. ~/.scripts/kubernetes.sh run redis sh
        args+=('--')
        args+=("${@:2}")
    else
        # has args or separator first
        # ie. ~/.scripts/kubernetes.sh run redis -- sh
        # ie. ~/.scripts/kubernetes.sh run redis -n istio-system
        for arg in "${@:2}"; do
            args+=("$arg")
            # NOTE: technically there may not be a command after the --, but tbh who gonna write -- at the end and nothing after it... :p (laziness)
            if [[ "$arg" == '--' ]]; then
                has_command='true'
            fi
        done

        # add command after args
        if [[ "$has_command" != 'true' ]]; then
            # run bash if it's available, fallback to sh
            args+=('--' 'sh' '-c' 'if type bash >/dev/null 2>&1; then bash; else sh; fi')
        fi
    fi

    # TODO: detect & kill istio sidecar...
    # TODO: consider: running 'sleep 86400' and then kube exec -it 'args...' (this way commands run don't show up in logs, especially useful if passwords are involved)

    # run
    # TODO: who dis? doesn't seem to work with my current kubectl version... --generator=run-pod/v1
    kubectl run "${USER}-testing-$(date '+%s')" --rm -it --restart=Never --image "$image" "${args[@]}"
}

kubernetes::import_kubeconfig() {
    # usage: kubeconf-import ~/some-kubeconfig ~/other-kubeconfig
    declare kubeconfig
    kubeconfig="${HOME}/.kube/config$(printf "%s" "${@/#/:}")"

    # NOTE: writing to a var instead of the file directly because > will wipe the file before it can be read by kubectl
    declare new_config
    new_config="$(KUBECONFIG="$kubeconfig" kubectl config view --flatten)"

    cat >~/.kube/config <<<"$new_config"
}

# kubernetes::pkubectl() {
#     # essentially pssh but for k8s clusters
#     # TODO: Consider clusters not being positional (ie. more like pssh's -h -H args)
#     # ie. pkubectl 'gke_scorebet-staging_us-west2_cockroachdb-us-west2 gke_scorebet-staging_us-central1_cockroachdb-us-central1' get ns

#     # TODO: use 'parallel' to be able to run each in parallel
#     # NOTE: the echo is to make this split on space in zsh also
#     for context in $(echo "$1"); do
#         output::echo 'blue' "==> ${context}"
#         kubectl --context "$context" "${@:2}"
#     done
# }

kubernetes::main() {
    case "$1" in
        run)
            kubernetes::run "${@:2}"
            ;;
        import-kubeconfig)
            kubernetes::import_kubeconfig "${@:2}"
            ;;
        # pkubectl)
        #     kubernetes::pkubectl "${@:2}"
        #     ;;
        *)
            echo 'usage: '
            echo '  ~/.scripts/kubernetes.sh run'
            echo '  ~/.scripts/kubernetes.sh import-kubeconfig <file>...'
            # echo '  ~/.scripts/kubernetes.sh pkubectl'
            ;;
    esac
}

kubernetes::main "$@"
