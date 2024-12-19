#!/usr/bin/env zsh
#
#  ~/.zshenv
#             _
#     ___ ___| |_ ___ ___ _ _
#   _|- _|_ -|   | -_|   | | |
#  |_|___|___|_|_|___|_|_|\_/
#
#  ~/.zshenv: Zsh environment file, always loaded.

#
# Base XDG Directories
#

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
# XDG base directories not in specification.
export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}

#
# Zsh
#

export ZDOTDIR=${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}

#
# GnuPG
#

# This must be set as early as possible to avoid issues with SSH sign-in.
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi