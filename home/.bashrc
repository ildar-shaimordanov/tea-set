#!/bin/bash

# Workaround to avoid the existing issue of sourcing from /etc/profile
# https://github.com/msysgit/msysgit/pull/231
case "$OSTYPE" in
msys*)
	[ "${BASH_SOURCE[1]}" == "/etc/profile" ] && return
	;;
esac
## echo "${BASH_SOURCE[@]}"

# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

# base-files version 4.1-1

# ~/.bashrc: executed by bash(1) for interactive shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
# shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
#
# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Increase the history size and the history file size
export HISTSIZE=2000
export HISTFILESIZE=20000
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# =========================================================================

if [ -d "${HOME}/.bash" ]
then
	# Common settings
	[ -f "${HOME}/.bash/settings" ] \
	&& . "${HOME}/.bash/settings"

	# Common functions
	for f in $( ls ${HOME}/.bash/functions-* )
	do
		[ -e "$f" ] \
		&& . "$f"
	done

	# Common aliases
	[ -f "${HOME}/.bash/aliases" ] \
	&& . "${HOME}/.bash/aliases"
fi

# =========================================================================

# Git settings
if ! declare -F | grep -q _git
then
	if [ -f "/mingw32/share/git/completion/git-completion.bash" ]
	then
		. "/mingw32/share/git/completion/git-completion.bash"
	elif [ -f "/etc/git-completion.bash" ]
	then
		. "/etc/git-completion.bash"
	elif [ -f "$HOME/.git-completion.bash" ]
	then
		. "$HOME/.git-completion.bash"
	fi


	if [ -f "/mingw32/share/git/completion/git-prompt.sh" ]
	then
		. "/mingw32/share/git/completion/git-prompt.sh"
	elif [ -f "/etc/git-prompt.sh" ]
	then
		. "/etc/git-prompt.sh"
	elif [ -f "$HOME/.git-prompt.sh" ]
	then
		. "$HOME/.git-prompt.sh"
	fi

	GIT_PS1_SHOWCOLORHINTS=1
	PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\` __git_ps1 \`\n\$ "
fi

# =========================================================================

# EOF
