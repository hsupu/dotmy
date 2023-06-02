
# conf handling module
__wsl_conf_read() {
	[[ -f /etc/wsl.conf ]] && sed -nr "/^\[${1}\]/ { :l /^${2}[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" /etc/wsl.conf
}

# /etc/wsl.conf
# [interop]
# enabled = true # default
#
is_interop_enabled() {
	if __wsl_conf_read interop enabled | grep false > /dev/null; then
		return 1
	return 0
}

