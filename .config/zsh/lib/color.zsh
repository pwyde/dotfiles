#
# color.zsh - Add color to Zsh.
#

# Built-in Zsh colors.
autoload -Uz colors && colors

# Show man pages in color.
export LESS_TERMCAP_mb=$'\e[01;34m'      # mb:=start blink-mode (bold,blue)
export LESS_TERMCAP_md=$'\e[01;34m'      # md:=start bold-mode (bold,blue)
export LESS_TERMCAP_so=$'\e[00;47;30m'   # so:=start standout-mode (white bg, black fg)
export LESS_TERMCAP_us=$'\e[04;35m'      # us:=start underline-mode (underline magenta)
export LESS_TERMCAP_se=$'\e[0m'          # se:=end standout-mode
export LESS_TERMCAP_ue=$'\e[0m'          # ue:=end underline-mode
export LESS_TERMCAP_me=$'\e[0m'          # me:=end modes

# Set LS_COLORS using (g)dircolors if found.
if [[ -z "$LS_COLORS" ]]; then
  _dircolors_cmds=(
    $commands[dircolors](N) $commands[gdircolors](N)
  )
  if (( $#_dircolors_cmds )); then
    source <("$_dircolors_cmds[1]" --sh)
  fi
  unset _dircolors_cmds

  # Pick a reasonable default for LS_COLORS if it has been set by this point.
  export LS_COLORS="${LS_COLORS:-di=34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43}"
fi

# Missing dircolors is a good indicator of a BSD system. Set LSCOLORS for macOS/BSD.
if (( ! $+commands[dircolors] )); then
  # For BSD systems, set LSCOLORS.
  export CLICOLOR=${CLICOLOR:-1}
  export LSCOLORS="${LSCOLORS:-exfxcxdxbxGxDxabagacad}"
fi

#
# Aliases
#

# Print a simple colormap.
alias colormap='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+"\n"}; done'

# Set colors for ls.
alias ls="${aliases[ls]:-ls} --color=auto"

# Set colors for grep.
alias grep="${aliases[grep]:-grep} --color=auto"

# Set colors for diff.
if command diff --color /dev/null{,} &>/dev/null; then
  alias diff="${aliases[diff]:-diff} --color"
fi

#
# Completions
#

# Colorize completions.
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
