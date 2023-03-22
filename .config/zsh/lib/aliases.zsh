#!/usr/bin/env zsh

################################################################################
#  CONFIGURE ALIASES
################################################################################

# Directory navigation.
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
# Directory management.
alias md='mkdir -p'
alias rmdir='rm -rf'

## Listing files and directories.
#alias lsa='ls -lAh'
#alias la='ls -lAh'
#alias l='ls -lh'
#alias ll='ls -lh'
# Check if exa should display icons or not.
if [[ -z $DISPLAY ]]; then
    # Test if session is virtual console (tty) or other.
    if [[ $(tty) = /dev/tty[0-9]* ]]; then
        # Running in console, do not display icons in exa.
        alias ls='exa'
        alias la='exa --long --group --header --all'
        alias l='exa --long --group --header'
        alias ll='exa --long --group --header'
    else
        # Running Xorg/Wayland, display icons in exa.
        alias ls='exa --icons'
        alias la='exa --long --group --header --all --icons'
        alias l='exa --long --group --header --icons'
        alias ll='exa --long --group --header --icons'
    fi
else
    # Running Xorg/Wayland, display icons in exa.
    alias ls='exa --icons'
    alias la='exa --long --group --header --all --icons'
    alias l='exa --long --group --header --icons'
    alias ll='exa --long --group --header --icons'
fi

alias cat='bat --theme base16'
alias find='fd'
alias grep='rg'
alias less="less -R"
alias ps='procs --tree'

# Always add full time-date stamps in ISO8601 'yyyy-mm-dd hh:mm' format to the
# 'history' command.
alias history="history -i"

# Aliases exempted from spelling correction.
alias cp='nocorrect cp'
alias gist='nocorrect gist'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias sudo='nocorrect sudo'

### Custom aliases.
# Untar gzip.
alias untarz="tar -xvzf"
# Untar bzip2.
alias untarb="tar -xvjf"
# Untar xz.
alias untarx="tar -xvJf"
# Show all processes.
#alias ps="ps aux" # Replaced with procs command-line utility.
# Enable acme.sh for issuing Let's Encrypt certificates.
alias acme.sh="/home/patrik/.local/opt/acme.sh/acme.sh --config-home '/home/patrik/.config/acme.sh'"

### Custom oneliners.
alias update-arch="sudo pacman -Syu"
alias update-ubuntu="sudo apt update && sudo apt upgrade && sudo apt autoremove"
