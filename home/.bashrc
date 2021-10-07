#! ~/.bashrc

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
#
# Strip the ".exe" extension when use the bash autocompletion feature
shopt -s completion_strip_exe

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
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
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

# The CYGWIN environment variable
#
# https://www.cygwin.com/cygwin-ug-net/using-cygwinenv.html
# https://www.cygwin.com/cygwin-ug-net/using.html#pathnames-symlinks
#
# winsymlinks:{lnk,native,nativestrict}
#
# if set to just winsymlinks or winsymlinks:lnk, Cygwin creates symlinks
# as Windows shortcuts with a special header and the R/O attribute set.
#
# If set to winsymlinks:native or winsymlinks:nativestrict, Cygwin
# creates symlinks as native Windows symlinks on filesystems and OS
# versions supporting them.
#
# The difference between winsymlinks:native and winsymlinks:nativestrict
# is this: If the filesystem supports native symlinks and Cygwin fails
# to create a native symlink for some reason, it will fall back to
# creating Cygwin default symlinks with winsymlinks:native, while with
# winsymlinks:nativestrict the symlink(2) system call will immediately
# fail.

export CYGWIN="winsymlinks"

# =========================================================================

# Clean the variable reserved for custom MOTD before using it. See the
# details below to understand the concept of the feature.
unset BASH_PROFILE_MOTD

if [ -d "${HOME}/.bash" ]
then
	# Environment, functions, some setings and aliases: in this order
	for f in 				\
		"${HOME}/.bash"/environ		\
		"${HOME}/.bash"/functions-*	\
		"${HOME}/.bash"/settings-*	\
		"${HOME}/.bash"/aliases		\

	do
		[ -f "$f" ] \
		&& . "$f"
	done
fi

# Either "~/.bashrc" or any of "~/.bash/*" can define its own message
# of the day (MOTD). Each MOTD should be correct shell code that
# will be executed after sourcing all "~/.bash/*" and "~/.bashrc"
# files. They should be added (either prepended or appended) to the
# "$BASH_PROFILE_MOTD" variable. The easiest way to declare MOTD is
# as follows:
#
# BASH_PROFILE_MOTD="$BASH_PROFILE_MOTD
# : some code here if needed
# cat <<MOTD
# some text here
# MOTD
# : another code if needed
# "
eval "$BASH_PROFILE_MOTD"

# =========================================================================

# EOF
