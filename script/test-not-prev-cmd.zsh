#!/usr/bin/env zsh

SCRIPT_DIR=$(dirname "$0")
TEST_DIR=$SCRIPT_DIR/../test
DIST_DIR=$SCRIPT_DIR/../

source $TEST_DIR/stub-1.0.2.sh

source $DIST_DIR/zsh-autosuggestions.zsh

#--------------------------------------------------------------------#
# Default Suggestions Strategy                                       #
#--------------------------------------------------------------------#

TMPHIST_FILE=/tmp/zsh-autosuggestions-test-tmp-hist

# Use stub.sh for stubbing/mocking
HISTSIZE=0  # Clear history
HISTSIZE=100

cat > $TMPHIST_FILE <<-EOH
	one
	two
	three
	four
	five
	six
	seven
	eight
	nine
	ten
	eleven
EOH
echo >> $TMPHIST_FILE

fc -R $TMPHIST_FILE

rm $TMPHIST_FILE

ZSH_AUTOSUGGEST_STRATEGY=default

stub_and_echo _zsh_autosuggest_prev_command "eleven"

testNotPrevCmd() {
	unset ZSH_AUTOSUGGEST_PREV_CMD

	assertEquals \
		"Did not pick correct suggestion for prefix 'e'" \
		"" \
		"$(_zsh_autosuggest_suggestion e)"

	assertEquals \
		"Did not pick correct suggestion for prefix 'ei'" \
		"eight" \
		"$(_zsh_autosuggest_suggestion ei)"
}

testYesPrevCmd() {
	ZSH_AUTOSUGGEST_PREV_CMD=1

	assertEquals \
		"Did not pick correct suggestion for prefix 'e'" \
		"eleven" \
		"$(_zsh_autosuggest_suggestion e)"

	assertEquals \
		"Did not pick correct suggestion for prefix 'ei'" \
		"eight" \
		"$(_zsh_autosuggest_suggestion ei)"
}

setopt shwordsplit
SHUNIT_PARENT=$0

source $TEST_DIR/shunit2-2.1.6/src/shunit2

