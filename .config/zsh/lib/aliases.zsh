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
# Using ls command.
#alias lsa='ls -lAh'
#alias la='ls -lAh'
#alias l='ls -lh'
#alias ll='ls -lh'
# Using exa command-line utility.
alias ls='exa'
alias la='exa --long --all'
alias l='exa --long'
alias ll='exa --long'

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

### Custom oneliners.
alias update-arch="sudo pacman -Syu"
alias update-ubuntu="sudo apt update && sudo apt upgrade && sudo apt autoremove"
alias tarbak-system='sudo tar --exclude="/dev" --exclude="/home" --exclude="/lost+found" --exclude="/proc" --exclude="/run" --exclude="/sys" --exclude="/tmp" --exclude="/var/lib/libvirt/media" --exclude="/var/lib/libvirt/images" --exclude="/var/lock" --exclude="/var/run" --exclude="/var/tmp" --xattrs -czpvf /home/patrik/Shares/Backups/Hosts/$(hostname)-system_backup-$(date +%Y.%m.%d).tar.gz /'
alias tarbak-home='tar --exclude="/home/patrik/.cache" --exclude="/home/patrik/.electron" --exclude="/home/patrik/.java" --exclude="/home/patrik/.local/share/Steam" --exclude="/home/patrik/.node-gyp" --exclude="/home/patrik/.npm" --exclude="/home/patrik/.nv" --exclude="/home/patrik/.pki" --exclude="/home/patrik/.putty" --exclude="/home/patrik/.steam" --exclude="/home/patrik/.thumbnails" --exclude="/home/patrik/.tor-browser" --exclude="/home/patrik/.uml" --exclude="/home/patrik/Build" --exclude="/home/patrik/Shares" --exclude="/home/patrik/.steampath" --exclude="/home/patrik/.steampid" --xattrs -czpvf /home/patrik/Shares/Backups/Hosts/$(hostname)-home_backup-$(date +%Y.%m.%d).tar.gz /home/patrik'
