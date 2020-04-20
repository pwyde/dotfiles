#!/bin/bash

# Copyright (C) 2018 Patrik Wyde <patrik@wyde.se>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Script for adding SSH key passphrases to the KDE Wallet. Keys are only
# added if the ssh-agent is running, for example via a systemd user service
# $HOME/.config/systemd/user/ssh-agent.service:
#
# [Unit]
# Description=SSH key agent
#
# [Service]
# Type=simple
# Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
# ExecStart=/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK
#
# [Install]
# WantedBy=default.target
#
# Script requires a properly configured pam_env via the $HOME/.pam_environment
# configuration file:
#
# SSH_AUTH_SOCK  DEFAULT="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# Check if KDE Plasma is installed on system and running.
if [[ -f "/usr/bin/plasmashell" && "$(pidof plasmashell | wc -w)" = "1" ]]; then
    # Check if ssh-agent is running. If not after 10 sec, exit script.
    try=0
    while [[ ! -S "${XDG_RUNTIME_DIR}/ssh-agent.socket" ]]; do
        [ $try -ge 10 ] && exit
        sleep 1
        try=$((try + 1))
    done
    # Check if KDE Wallet is open. If not open after 10 sec, exit script.
    # If true, loop through .ssh directory and add all private keys using
    # ssh-add.
    try=0
    while [[ ! -S "${PAM_KWALLET5_LOGIN}" ]]; do
        [ $try -ge 10 ] && exit
        sleep 1
        try=$((try + 1))
    done
    dotssh_dir="${HOME}/.ssh"
    for FILE in "${dotssh_dir}"/*; do
        file "${FILE}" | grep -Eq "private key$" && ssh-add "${FILE}" </dev/null
    done
fi
