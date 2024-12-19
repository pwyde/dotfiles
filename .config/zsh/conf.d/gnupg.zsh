# Variable used by ssh-agent systemd user service: ~/.config/systemd/user/ssh-agent.service
#SSH_AUTH_SOCK  DEFAULT="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# Set the following variables to communicate with gpg-agent instead of the default ssh-agent.
# Reference:
# - https://wiki.archlinux.org/title/GnuPG#SSH_agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi