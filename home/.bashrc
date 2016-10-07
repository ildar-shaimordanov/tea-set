#!/bin/bash

# Workaround to avoid the existing issue of sourcing from /etc/profile
# https://github.com/msysgit/msysgit/pull/231
case "$OSTYPE" in
msys*)
	[ "${BASH_SOURCE[1]}" == "/etc/profile" ] && return
	;;
esac
## echo "${BASH_SOURCE[@]}"

# =========================================================================

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
	# Common settings, functions and aliases in this order
	for f in \
		"${HOME}/.bash/settings" \
		$( ls ${HOME}/.bash/functions-* 2>/dev/null ) \
		"${HOME}/.bash/aliases"
	do
		[ -f "$f" ] \
		&& . "$f"
	done
fi

# =========================================================================

# Git settings
if ! declare -F | grep -q _git
then
	for f in \
		"$HOME/.git-completion.bash" \
		"/etc/git-completion.bash" \
		"/mingw64/share/git/completion/git-completion.bash" \
		"/mingw32/share/git/completion/git-completion.bash" \

	do
		if [ -f "$f" ]
		then
			. "$f"
			break
		fi
	done

	for f in \
		"$HOME/.git-prompt.sh" \
		"/etc/git-prompt.sh" \
		"/mingw64/share/git/completion/git-prompt.sh" \
		"/mingw32/share/git/completion/git-prompt.sh" \

	do
		if [ -f "$f" ]
		then
			. "$f"
			break
		fi
	done

	unset f


	PS1="\[\e]0;\w\a\]"			# current dir in title

	PS1="${PS1}\n"				# new line
	PS1="${PS1}\[\e[32m\]"			# color: dark green
	PS1="${PS1}\u@\h "			# user@host <space>

	PS1="${PS1}\[\e[35m\]"			# color: purple
	PS1="${PS1}${MSYSTEM:-$OSTYPE} "	# $MSYSTEM/$OSTYPE <space>

	PS1="${PS1}\[\e[33m\]"			# color: dark yellow
	PS1="${PS1}\w"				# current dir

	PS1="${PS1}\[\e[0m\]"			# color: reset to default
	if declare -F __git_ps1 >/dev/null
	then
		GIT_PS1_SHOWCOLORHINTS=1
		PS1="${PS1}\` __git_ps1 \`"	# git status
	fi

	PS1="${PS1}\n"				# new line
	PS1="${PS1}\\\$ "			# $ <space>
fi

# =========================================================================

# EOF
