#!/usr/bin/env zsh

################################################################################
#  CONFIGURE COLORS
################################################################################

# Enable dircolors.
if type -p dircolors &>/dev/null; then
    #  Enable custom colors if it exists.
    [ -e "${XDG_CONFIG_HOME}/dircolors" ] && \
    eval "$(dircolors -b "${XDG_CONFIG_HOME}/dircolors")" || \
    eval "$(dircolors -b)"
fi

# Colorize 'ls' command. Based on Oh My Zsh;
# https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/theme-and-appearance.zsh
#
# Note: Must be run before enabling $LS_COLORS for directories in completion
#       menu. See ${ZLIB}/completion.zsh for more information.
ls --color -d . &>/dev/null && alias ls='ls --color=tty' || { ls -G . &>/dev/null && alias ls='ls -G' }

alias vdir="vdir --color=auto"      # Colorize 'vdir' command.

alias grep="grep --color=auto -i"   # Colorize 'grep' command and ignore case.
alias fgrep="grep --color=auto -i"  # Colorize 'fgrep' command and ignore case.
alias egrep="grep --color=auto -i"  # Colorize 'egrep' command and ignore case.

alias diff="diff --color=auto"      # Colorize 'diff' command.
