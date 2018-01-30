function ensureRoot() {
	if [[ "$EUID" -ne 0 ]]; then
	   echo "must be run as root" 1>&2
	   exit 1
	fi
}
