# 1. Install MSysGit
# 2. Put this file into your Windows home dir (usually located in C:\Users)
# 3. Specify new home dir in the particular line below

# Workaround to avoid the existing issue of sourcing from /etc/profile
# https://github.com/msysgit/msysgit/pull/231
case "$OSTYPE" in
msys*)
	[ "${BASH_SOURCE[1]}" == "/etc/profile" ] && return
	;;
esac
## echo "${BASH_SOURCE[@]}"

# Set new home dir
HOME='PUT_THE_REAL_PATH_TO_NEW_HOME_DIR'
HOME="$( cd "$HOME" ; pwd )"
export HOME

# Set history file
export HISTFILE="$HOME/.bash_history"

[ -f "$HOME/.bash_profile" ] \
&& . "$HOME/.bash_profile"

