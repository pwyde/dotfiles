#
# history.zsh - Set history options and define history aliases.
#

# References:
# - https://github.com/sorin-ionescu/prezto/tree/master/modules/history
# - https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/history.zsh
# - https://zsh.sourceforge.io/Doc/Release/Options.html#History

#
# Options
#

# Set Zsh options related to history.
setopt bang_hist               # Treat the '!' character specially during expansion.
setopt extended_history        # Write the history file in the ':start:elapsed;command' format.
setopt hist_expire_dups_first  # Expire a duplicate event first when trimming history.
setopt hist_find_no_dups       # Do not display a previously found event.
setopt hist_ignore_all_dups    # Delete an old recorded event if a new event is a duplicate.
setopt hist_ignore_dups        # Do not record an event that was just recorded again.
setopt hist_ignore_space       # Do not record an event starting with a space.
setopt hist_reduce_blanks      # Remove extra blanks from commands added to the history list.
setopt hist_save_no_dups       # Do not write a duplicate event to the history file.
setopt hist_verify             # Do not execute immediately upon history expansion.
setopt inc_append_history      # Write to the history file immediately, not when the shell exits.
setopt share_history           # Share history between all sessions.
setopt NO_hist_beep            # Do not beep when accessing non-existent history.

# Set the path to the default history file.
if zstyle -s ':zrc:history' file 'HISTFILE'; then
  # Make sure the HISTFILE does not start with a leading '~'.
  HISTFILE="${~HISTFILE}"
else
  HISTFILE="${__zsh_user_data_dir}/zsh_history"
fi

# Create path to history file if it does not exist.
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"

# Set history file size.
zstyle -s ':zrc:history' savehist 'SAVEHIST' \
  || SAVEHIST=100000
# Set session history size.
zstyle -s ':zrc:history' histsize 'HISTSIZE' \
  || HISTSIZE=20000

#
# Aliases
#

# Always add full time-date stamps in ISO8601 'yyyy-mm-dd hh:mm' format.
alias history="${aliases[history]:-history} -i"
alias hist='fc -li'
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
