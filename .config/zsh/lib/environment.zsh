#
# environment.zsh - Set common Zsh environment options and variables.
#

# References:
# - https://github.com/sorin-ionescu/prezto/blob/master/modules/environment/init.zsh
# - https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zprofile

#
# Options
#

# Set Zsh options related to globbing.
setopt extended_glob         # Use more awesome globbing features.

# Set general Zsh options.
setopt combining_chars       # Combine 0-len chars with the base character (eg: accents).
setopt interactive_comments  # Enable comments in interactive shell.
# setopt rc_quotes             # Allow 'Hitchhikers''s Guide' instead of 'Hitchhikers'\''s Guide'.
setopt NO_mail_warning       # Do not print a warning message if a mail file has been accessed.
setopt NO_beep               # Do not beep on error in line editor.

# Set Zsh options related to job control.
setopt auto_resume           # Attempt to resume existing job before creating a new process.
setopt long_list_jobs        # List jobs in the long format by default.
setopt notify                # Report status of background jobs immediately.
setopt NO_bg_nice            # Do not run all background jobs at a lower priority.
setopt NO_check_jobs         # Do not report on jobs when shell exit.
setopt NO_hup                # Do not kill jobs on shell exit.

#
# Base XDG Directories
#

# Set XDG base directories. This is already handled by ~/.zshenv and ~/.zshrc.
# References:
# - https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
# export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
# export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
# export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
# mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME $XDG_STATE_HOME

#
# Editors
#

export EDITOR=${EDITOR:-vim}
export VISUAL=${VISUAL:-vim}
export PAGER=${PAGER:-less}

# Set the default less options.
# Mouse-wheel scrolling can be disabled with -X (disable screen clearing).
# Add -X to disable it.
if [[ -z "$LESS" ]]; then
  export LESS='-g -i -M -R -S -w -z-4'
fi

# Set the less input preprocessor.
# Try both 'lesspipe' and 'lesspipe.sh' as either might exist on a system.
if [[ -z "$LESSOPEN" ]] && (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# Reduce key delay.
export KEYTIMEOUT=${KEYTIMEOUT:-1}

# Use '< file' to quickly view the contents of any file.
[[ -z "$READNULLCMD" ]] || READNULLCMD=$PAGER

#
# XDG Directories
#

# acme.sh
export LE_WORKING_DIR="${HOME}/.local/opt/acme.sh"
export LE_CONFIG_HOME="${HOME}/.config/acme.sh"

# Docker
_docker_status=$(systemctl --user is-active docker 2>&1)
# Check if Docker daemon is running in rootless mode.
if [[ "$docker_status" == "active" ]]; then
    export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
    export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/docker.sock"
fi
unset _docker_status

# Kubernetes
export KUBECONFIG="${XDG_CONFIG_HOME}/kube"
export KUBECACHEDIR="${XDG_CACHE_HOME}/kube"

# KDE
export KDEHOME="${XDG_CONFIG_HOME}/kde"

# Krew
export KREW_ROOT="${XDG_DATA_HOME}/krew"

# less
export LESSHISTFILE="-" # Disable less history.

# pass
export PASSWORD_STORE_DIR="${XDG_DATA_HOME}/pass"

# Rust/Cargo
export CARGO_HOME="${XDG_DATA_HOME}/cargo"

# SOPS
export SOPS_AGE_KEY_FILE="${XDG_CONFIG_HOME}/sops/age/keys.txt"

# SSH
# Set SSH_ASKPASS environment variable to ksshaskpass if present.
[[ -n $(command -v ksshaskpass) ]] && export SSH_ASKPASS="/usr/bin/ksshaskpass"

# wget
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"

# Vim
export VIMINIT=":source $XDG_CONFIG_HOME/vim/vimrc"

# xinit
export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
export XSERVERRC="${XDG_CONFIG_HOME}/X11/xserverrc"

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Add /usr/local/bin to path.
path=(/usr/local/{,s}bin(N) $path)

# Set the list of directories that Zsh searches for programs.
if [[ ! -v prepath ]]; then
  typeset -ga prepath
  # If path ever gets out of order, you can use 'path=($prepath $path)' to reset it.
  prepath=(
    $HOME/{,s}bin(N)
    $HOME/.local/{,s}bin(N)
    $HOME/.config/autostart-scripts(N)
    $HOME/.local/krew/bin(N)
  )
fi
path=(
  $prepath
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $path
)

#
# Operating System
#

# Operating system identification.
# Reference:
# - https://www.freedesktop.org/software/systemd/man/os-release.html
[ -f "/etc/os-release" ] && source /etc/os-release
