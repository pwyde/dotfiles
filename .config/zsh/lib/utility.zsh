#
# utility.zsh - Misc Zsh shell options and utilities.
#

# References:
# - https://github.com/sorin-ionescu/prezto/blob/master/modules/utility/init.zsh
# - https://github.com/belak/zsh-utils/blob/main/utility/utility.plugin.zshc

# Use built-in paste magic.
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Load more specific 'run-help' function from $fpath.
(( $+aliases[run-help] )) && unalias run-help && autoload -Uz run-help
alias help=run-help

#
# Aliases
#

# Make ls more useful and group directories first.
alias ls="${aliases[ls]:-ls} --group-directories-first"
# Show human readable file sizes.
alias ls="${aliases[ls]:-ls} -h"
