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

# Aliases
#
# Some people use a different file for aliases
# if [ -f "${HOME}/.bash_aliases" ]; then
#   source "${HOME}/.bash_aliases"
# fi
#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
# alias grep='grep --color'                     # show differences in colour
# alias egrep='egrep --color=auto'              # show differences in colour
# alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
# alias ls='ls -hF --color=tty'                 # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
# alias ll='ls -l'                              # long list
# alias la='ls -A'                              # all but . and ..
# alias l='ls -CF'                              #

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions
#
# Some people use a different file for functions
# if [ -f "${HOME}/.bash_functions" ]; then
#   source "${HOME}/.bash_functions"
# fi
#
# Some example functions:
#
# a) function settitle
# settitle () 
# { 
#   echo -ne "\e]2;$@\a\e]1;$@\a"; 
# }
# 
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping, 
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
# 
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
# 
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
# 
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
# 
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
# 
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
# 
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
# 
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
# 
#   return 0
# }
# 
# alias cd=cd_func

# =========================================================================

now() {
	date "+${1:-%F %T}"
}

# =========================================================================

# Perl version of sponge
# http://backreference.org/2011/01/29/in-place-editing-of-files/
# http://joeyh.name/code/moreutils/
sponge() {
	typeset FN="sponge"

	if [ $# -ne 1 -o -z "$1" ]
	then
		cat <<HELP
NAME
	$FN - Soak up standard input and write to a file

USAGE
	command FILE | $FN FILE

DESCRIPTION
	The function reads standard input and writes it out to the 
	specified file. Unlike a shell redirect, The function soaks up all 
	its input before opening the output file. This allows constructing 
	pipelines that read from and write to the same file.
HELP
		return
	fi

	perl -ne 'push @lines, $_; END { open(OUT, ">$file") or die "sponge: cannot open $file: $!\n"; print OUT @lines; close(OUT); }' -s -- -file="$1"
#	perl -e '@lines = <>; open(OUT, ">$file") or die "sponge: cannot open $file: $!\n"; print OUT @lines; close(OUT);' -s -- -file="$1"
}

# =========================================================================

j2() {
	sed "N;s/\n/$1/"
	#paste -sd "$1\n"
}

jn() {
	sed ":a;N;s/\n/$1/;ta"
	#paste -sd"$1"
}

# =========================================================================

image2pdf() {
	convert -adjoin -format pdf "$@"
}

img2pdf() {
	jpegtopnm "${1:--}" | pnmtops -noturn | ps2pdf - "${2:--}"
}

__conv_image2folder() {
	convert "${1:-cover-front.jpg}" -resize '300x300>' "folder.jpg"
}

__conv_left2folder() {
	convert "${1:-cover-front.jpg}" -resize '600x300>' -gravity west -crop '50%x100%' "folder.jpg"
}

__conv_right2folder() {
	convert "${1:-cover-front.jpg}" -resize '600x300>' -gravity east -crop '50%x100%' "folder.jpg"
}

# =========================================================================

# http://www.commandlinefu.com/commands/view/11246/bashksh-function-given-a-file-cd-to-the-directory-it-lives
cdf() {
	[ $# -eq 1 ] || {
		echo "Usage: $FUNCNAME filename">&2
		return 1
	}

	cd "$( [ -f "$1" ] && dirname "$1" || echo "$1" )"
}

# http://www.commandlinefu.com/commands/view/13604/change-directory-for-current-path-in-bash
cdd() {
	[ $# -eq 2 ] || {
		echo "Usage: $FUNCNAME old_dir new_dir">&2
		return 1
	}

	cd "$( pwd | sed -e "s/$1/$2/" )"
}

# http://www.commandlinefu.com/commands/view/12669/create-a-directory-and-change-into-it-at-the-same-time
mkcd() {
	[ $# -eq 1 ] || {
		echo "Usage: $FUNCNAME dirname">&2
		return 1
	}

	mkdir "$1" && cd "$1"
}

# http://code.metager.de/source/xref/gnu/bash/examples/functions/ksh-cd
#
#  Chet Ramey <chet.ramey@case.edu>
#
#  Copyright 2001 Chester Ramey
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2, or (at your option)
#   any later version.
#
#   TThis program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software Foundation,
#   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#
# ksh-like `cd': cd [-LP] [dir [change]]
#
cd()
{
	local CDOPTS
	local old
	local new
	local dir

	OPTIND=1
	while getopts "LP" opt
	do
		case $opt in
		L|P)	CDOPTS="$CDOPTS -$opt" ;;
		*)	echo "$FUNCNAME: usage: $FUNCNAME [-LP] [dir] [change]" >&2
			return 2;;
		esac
	done

	shift $(( $OPTIND - 1 ))

	case $# in
	0)	builtin cd $CDOPTS "$HOME" ;;
	1) 	builtin cd $CDOPTS "$@" ;;
	2)	old="$1" new="$2"
		case "$PWD" in
		*$old*)	;;
		*)	 echo "${0##*/}: $FUNCNAME: bad substitution" >&2 ; return 1 ;;
		esac

		dir=${PWD//$old/$new}

		builtin cd $CDOPTS "$dir" && echo "$PWD"

		;;
	*)	echo "${0##*/}: $FUNCNAME: usage: $FUNCNAME [-LP] [dir] [change]" >&2
		return 2 ;;
	esac
}

# =========================================================================

# pwd -W for cygwin
uname | grep -iq cygwin && pwd() {
	case "$1" in
	-W )
		cygpath -m "$PWD"
		;;
	* )
		builtin pwd "$@"
		;;
	esac
}

# =========================================================================

# http://stackoverflow.com/q/8800578/100073
# https://retracile.net/blog/2013/06/01/22.00
# http://www.colordiff.org/
diff() {
	[ $# -gt 0 ] || {
		cat - <<HELP
Usage: $FUNCNAME [OPTION]... FILES

Wrapper for diff to colorize output of diff for better readability.
Try "diff --help" for more information.

OPTIONS

Diff options

All options will be passed to "diff".

Coloring options

--color[=WHEN], --colour[=WHEN]

Controls the colorizing method. WHEN is "always" (the default value if not 
specified explicitly), "never" or "auto". To make affect globally, set one 
of these values to CDIFF_COLOR environment variable.

ENVIRONMENT VARIABLES

The following environment variables are used to customize colors of the 
separate parts of the diff output. Values of each variables are ANSI 
escape codes. Names and resposibility of each variable correspond to the 
the configuration parameters "color.diff.<slot>" in "git config":

CDIFF_META
Metainformation (names of compared files)

CDIFF_FRAG
Hunk header (line numbers of changed lines)

CDIFF_OLD 
Removed lines

CDIFF_NEW
Added lines

CDIFF_MOD
Modified lines

CDIFF_COLOR
Colorizing method does effect on all runs; assumes the same values as for 
the "--color" option. The default value is "auto" and can be superseded by 
the "--color" option.
HELP
		return
	}

	# Colors
	local diff_c_white='\x1b[37;1m'
	local diff_c_red='\x1b[31m'
	local diff_c_green='\x1b[32m'
	local diff_c_blue='\x1b[34m'
	local diff_c_cyan='\x1b[36m'
	local diff_c_reset='\x1b[0m'

	# Blocks
	local diff_b_meta="${CDIFF_META:-$diff_c_white}"
	local diff_b_frag="${CDIFF_FRAG:-$diff_c_cyan}"
	local diff_b_old="${CDIFF_OLD:-$diff_c_red}"
	local diff_b_new="${CDIFF_NEW:-$diff_c_green}"
	local diff_b_mod="${CDIFF_MOD:-$diff_c_blue}"

	# Schemes
	local diff_s_normal="
		# diff ...
		# File headers
		/^[A-Za-z]/ s/^/$diff_b_meta/;

		# Difference headers
		/^[0-9]/ s/^/$diff_b_frag/;

		# Changed lines
		/^< / s/^/$diff_b_old/;
		/^> / s/^/$diff_b_new/;
	"
	local diff_s_context="
		# diff -c ...
		# File headers
		/^[A-Za-z0-9]/ s/^/$diff_b_meta/;
		/^\**$/ s/^/$diff_b_meta/;

		# File or difference headers 
		/^\*\*\* / {
			/\*\*\*\*$/! s/^/$diff_b_meta/;
			/\*\*\*\*$/  s/^/$diff_b_frag/;
		};
		/^--- / {
			/----$/! s/^/$diff_b_meta/;
			/----$/  s/^/$diff_b_frag/;
		};

		# Changed lines
		/^! / s/^/$diff_b_mod/;
		/^- / s/^/$diff_b_old/;
		/^+ / s/^/$diff_b_new/;
	"
	local diff_s_unified="
		# diff -u ...
		# File headers
		/^[A-Za-z]/ s/^/$diff_b_meta/;
		/^--- / s/^/$diff_b_meta/;
		/^+++ / s/^/$diff_b_meta/;

		# Difference headers
		/^@@ [^@]* [^@]* @@/ s/^/$diff_b_frag/;

		# Changed lines
		/^-/ s/^/$diff_b_old/;
		/^+/ s/^/$diff_b_new/;
	"
	local diff_s_ed="
		# diff -e ...
		# File headers
		/^diff \(-e\|--ed\) / s/^/$diff_b_meta/;
		/^Common subdirectories: / s/^/$diff_b_meta/;
		/^Only in / s/^/$diff_b_meta/;
		/^Files .* differ\$/ s/^/$diff_b_meta/;

		# Difference headers
		/^\([0-9][0-9]*,\)\?[0-9][0-9]*[acd]\$/ {
			/a\$/ s/^/$diff_b_new/;
			/c\$/ s/^/$diff_b_mod/;
			/d\$/ s/^/$diff_b_old/;
		}
	"
	local diff_s_rcs="
		# diff -n ...
		# File headers
		/^diff \(-n\|--rcs\) / s/^/$diff_b_meta/;
		/^Common subdirectories: / s/^/$diff_b_meta/;
		/^Only in / s/^/$diff_b_meta/;
		/^Files .* differ\$/ s/^/$diff_b_meta/;

		# Difference headers
		/^[ad][0-9][0-9]* [0-9][0-9]*\$/ {
			/^d/ s/^/$diff_b_old/;
			/^a/ s/^/$diff_b_new/;
		}
	"
	local diff_s_sidebyside="
		# diff -y ...
		# File headers
		/^diff \(-y\|--side-by-side\) / s/^/$diff_b_meta/;
		/^Common subdirectories: / s/^/$diff_b_meta/;
		/^Only in / s/^/$diff_b_meta/;
		/^Files .* differ\$/ s/^/$diff_b_meta/;

		# Changed lines
		/^.* <\$/ s/^/$diff_b_old/;
		/^.*[\t ]*|\t.*$/ s/^/$diff_b_mod/;
		/^[\t ]*>$/ s/^/$diff_b_new/;
		/^[\t ]*>\t.*/ s/^/$diff_b_new/;
	"

	local diff_scheme="$diff_s_normal"

	# Assume "auto" if not specified
	local CDIFF_COLOR="${CDIFF_COLOR:-auto}"

	# Validate environment variable
	case "$CDIFF_COLOR" in
	always | never | auto )
		# Do nothing: it is valid value
		;;
	* )
		echo "Invalid value '$CDIFF_COLOR' in CDIFF_COLOR" >&2
		return 2
		;;
	esac

	local -a args

	while [ $# -gt 0 ]
	do
		case "$1" in
		--help | -v | --version )
			diff_scheme=""
			break
			;;
		-- )
			break
			;;
		--color | --colour )
			CDIFF_COLOR=always
			;;
		--color=* | --colour=* )
			CDIFF_COLOR="${1#*=}"
			;;
		* )
			case "$1" in
			-c | -C* | --context | --context=* )
				diff_scheme="$diff_s_context"
				;;
			-p | --show-c-function )
				diff_scheme="$diff_s_context"
				;;
			-u | -U* |--unified | --unified=* )
				diff_scheme="$diff_s_unified"
				;;
			--normal )
				diff_scheme="$diff_s_normal"
				;;
			-e | --ed )
				diff_scheme="$diff_s_ed"
				;;
			-n | --rcs )
				diff_scheme="$diff_s_rcs"
				;;
			-y | --side-by-side )
				diff_scheme="$diff_s_sidebyside"
				;;
			esac
			args+=( "$1" )
			;;
		esac
		shift
	done

	case "$CDIFF_COLOR" in
	always )
		# Do nothing over defined by options
		;;
	never )
		diff_scheme=""
		;;
	auto )
		test -t 1 || diff_scheme=""
		;;
	* )
		echo "Invalid argument '$CDIFF_COLOR' for --color" >&2
		return 2
		;;
	esac

	args+=( "$@" )

	[ -z "$diff_scheme" ] && {
		env diff "${args[@]}"
		return $?
	}

	env diff "${args[@]}" | sed "$diff_scheme; s/\$/$diff_c_reset/"
}

# =========================================================================

# Common variables
[ -f "${HOME}/.sh_environment" ] \
&& . "${HOME}/.sh_environment"

# Common aliases
[ -f "${HOME}/.sh_aliases" ] \
&& . "${HOME}/.sh_aliases"

# Common functions
[ -f "${HOME}/.sh_functions" ] \
&& . "${HOME}/.sh_functions"

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
