#! ~/.bash_profile

#- # Workaround to avoid the existing issue of sourcing from /etc/profile
#- # https://github.com/msysgit/msysgit/pull/231
#- case "$OSTYPE" in
#- msys*)
#- 	[ "${BASH_SOURCE[1]}" == "/etc/profile" ] && return
#- 	;;
#- esac
#- ## echo "${BASH_SOURCE[@]}"

# =========================================================================

# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

# base-files version 4.1-1

# ~/.bash_profile: executed by bash(1) for login shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bash_profile

# Modifying /etc/skel/.bash_profile directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bash_profile) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bash_profile file

# =========================================================================

PATH="$PATH:$HOME/bin"

# =========================================================================

# Clean the variable reserved for custom MOTD before using it. See the 
# details below to understand the concept of this feature.
unset BASH_PROFILE_MOTD

# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

# Either "~/.bashrc" or any of "~/.bash/*" can define its own MOTD 
# (message of the day). They should be added (either prepended or 
# appended) to the "$BASH_PROFILE_MOTD" variable. Each MOTD should be 
# correct shell code taht will be executed after sourcing all "~/.bash/*" 
# and "~/.bashrc" files. The easiest way to declare MOTD is as follows:
#
# BASH_PROFILE_MOTD="$BASH_PROFILE_MOTD
# : some code here if needed
# cat <<MOTD
# some text here
# MOTD
# : another code if needed
# "
eval "$BASH_PROFILE_MOTD"

# Set PATH so it includes user's private bin if it exists
# if [ -d "${HOME}/bin" ] ; then
#   PATH="${HOME}/bin:${PATH}"
# fi

# Set MANPATH so it includes users' private man if it exists
# if [ -d "${HOME}/man" ]; then
#   MANPATH="${HOME}/man:${MANPATH}"
# fi

# Set INFOPATH so it includes users' private info if it exists
# if [ -d "${HOME}/info" ]; then
#   INFOPATH="${HOME}/info:${INFOPATH}"
# fi

# =========================================================================

# EOF
