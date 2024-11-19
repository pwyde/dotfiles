#!/usr/bin/env zsh

################################################################################
#  CONFIGURE ALIASES
################################################################################

### Directory Navigation
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

### Directory Management
alias md='mkdir -p'
alias rmdir='rm -rf'

### Listing Files & Directories
# Using ls command:
#alias lsa='ls -lAh'
#alias la='ls -lAh'
#alias l='ls -lh'
#alias ll='ls -lh'
# Using exa command-line utility:
# Check if exa should display icons or not.
# if [[ -z $DISPLAY ]]; then
#     # Test if session is virtual console (tty) or other.
#     if [[ $(tty) = /dev/tty[0-9]* ]]; then
#         # Running in console, do not display icons in exa.
#         alias ls='exa'
#         alias la='exa --long --group --group-directories-first --header --all'
#         alias l='exa --long --group --group-directories-first --header'
#         alias ll='exa --long --group --group-directories-first --header'
#     else
#         # Running Xorg/Wayland, display icons in exa.
#         alias ls='exa --icons'
#         alias la='exa --long --group --group-directories-first --header --all --icons'
#         alias l='exa --long --group --group-directories-first --header --icons'
#         alias ll='exa --long --group --group-directories-first --header --icons'
#     fi
# else
#     # Running Xorg/Wayland, display icons in exa.
#     alias ls='exa --icons'
#     alias la='exa --long --group --group-directories-first --header --all --icons'
#     alias l='exa --long --group --group-directories-first --header --icons'
#     alias ll='exa --long --group --group-directories-first --header --icons'
# fi
# Using eza command-line utility:
# Check if eza should display icons or not.
if [[ -z $DISPLAY ]]; then
    # Test if session is virtual console (tty) or other.
    if [[ $(tty) = /dev/tty[0-9]* ]]; then
        # Running in console, do not display icons in exa.
        alias ls='eza --color=always --icons=never'
        alias la='eza --color=always --long --group --group-directories-first --header --all --icons=never'
        alias l='eza --color=always --long --group --group-directories-first --header --icons=never'
        alias ll='eza --color=always --long --group --group-directories-first --header --icons=never'
    else
        # Running Xorg/Wayland, display icons in exa.
        alias ls='eza --color=always --icons=always'
        alias la='eza --color=always --long --group --group-directories-first --header --all --icons=always'
        alias l='eza --color=always --long --group --group-directories-first --header --icons=always'
        alias ll='eza --color=always --long --group --group-directories-first --header --icons=always'
    fi
else
    # Running Xorg/Wayland, display icons in exa.
    alias ls='eza --color=always --icons=always'
    alias la='eza --color=always --long --group --group-directories-first --header --all --icons=always'
    alias l='eza --color=always --long --group --group-directories-first --header --icons=always'
    alias ll='eza --color=always --long --group --group-directories-first --header --icons=always'
fi

### Command-line Utilities
alias cat='bat --theme base16'
alias bat='bat --theme base16'
alias find='fd'
alias grep='rg'
alias less="less -R"
# Replaced with procs command-line utility.
#alias ps="ps aux"
alias ps='procs --tree'

### Shell History
# Always add full time-date stamps in ISO8601 'yyyy-mm-dd hh:mm' format to the
# 'history' command.
alias history="history -i"

### Spelling
# Aliases exempted from spelling correction.
alias cp='nocorrect cp'
alias gist='nocorrect gist'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias sudo='nocorrect sudo'

### Custom Aliases
# Untar gzip.
alias untarz="tar -xvzf"
# Untar bzip2.
alias untarb="tar -xvjf"
# Untar xz.
alias untarx="tar -xvJf"
# Enable acme.sh for issuing Let's Encrypt certificates.
alias acme.sh="${HOME}/.local/opt/acme.sh/acme.sh --config-home '${HOME}/.config/acme.sh'"

### Custom Oneliners
alias paru="paru --batflags --theme=base16"
alias update-arch="paru -Syu"
alias update-ubuntu="sudo apt update && sudo apt upgrade && sudo apt autoremove"
