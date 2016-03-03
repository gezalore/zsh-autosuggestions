
#--------------------------------------------------------------------#
# Suggestion                                                         #
#--------------------------------------------------------------------#

# Delegate to the selected strategy to determine a suggestion
_zsh_autosuggest_suggestion() {
	local prefix="$1"
	local strategy_function="_zsh_autosuggest_strategy_$ZSH_AUTOSUGGEST_STRATEGY"

	if [ -n "$functions[$strategy_function]" ]; then
		local suggestion="$($strategy_function "$prefix")"

		if [[ -z "$ZSH_AUTOSUGGEST_PREV_CMD" && \
			"$suggestion" == "$(_zsh_autosuggest_prev_command)" ]]; then
			suggestion="";
		fi

		echo -E "$suggestion"
	fi
}

_zsh_autosuggest_escape_command_prefix() {
	setopt localoptions EXTENDED_GLOB

	# Escape special chars in the string (requires EXTENDED_GLOB)
	echo -E "${1//(#m)[\\()\[\]|*?]/\\$MATCH}"
}

# Get the previously executed command (hookable for testing)
_zsh_autosuggest_prev_command() {
	echo -E "${history[$((HISTCMD-1))]}"
}
