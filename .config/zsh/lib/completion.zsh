#
# completion.zsh - Setup Zsh completions.
#

# References:
# - https://github.com/mattmc3/zephyr/blob/main/plugins/completion/completion.plugin.zsh
# - https://github.com/mattmc3/zshrc1/blob/main/.zshrc1
# - https://github.com/mattmc3/ez-compinit/blob/main/ez-compinit.plugin.zsh
# - https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh#L31-L44
# - https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zlogin#L9-L15
# - http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Use-of-compinit
# - https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2894219
# - https://htr3n.github.io/2018/07/faster-zsh/

#
# Options
#

# Set completion options.
setopt always_to_end        # Move cursor to the end of a completed word.
setopt auto_list            # Automatically list choices on ambiguous completion.
setopt auto_menu            # Show completion menu on a successive tab press.
setopt auto_param_slash     # If completed parameter is a directory, add a trailing slash.
setopt complete_in_word     # Complete from both ends of a word.
setopt path_dirs            # Perform path search even on command names with slashes.
setopt NO_flow_control      # Disable start/stop characters in shell editor.
setopt NO_menu_complete     # Do not autoselect the first completion entry.

# Allow Fish-like user contributed completions.
fpath=($__zsh_config_dir/completions(-/FN) $fpath)

#
# Functions
#

# run-compinit: Initialize the built-in Zsh completion system.
function run-compinit {
  emulate -L zsh; setopt local_options $__zrc_opts

  # Set Zsh compdump file.
  typeset -g ZSH_COMPDUMP
  zstyle -s ':zrc:completion' compdump 'ZSH_COMPDUMP' ||
    ZSH_COMPDUMP=$__zsh_cache_dir/zcompdump

  # Make sure $ZSH_COMPDUMP path exists and does not have a leading tilde.
  ZSH_COMPDUMP="${~ZSH_COMPDUMP}"
  [[ -d "${ZSH_COMPDUMP:h}" ]] || mkdir -p "${ZSH_COMPDUMP:h}"

  # Forces a cache reset with 'run-compinit -f'.
  if [[ "$1" == (-f|--force) ]]; then
    shift
    [[ -r "$ZSH_COMPDUMP" ]] && rm -rf -- "$ZSH_COMPDUMP"
  fi

  # Load and initialize the completion system, disregarding insecure directories, with a cache
  # time of 20 hours. This configuration ensures that the completion system regenerates almost
  # daily upon the initial shell invocation.
  #
  # compinit flags:
  # -C        : Omit the check for new completion functions.
  # -i        : Ignore insecure directories in fpath.
  # -d <file> : Specify zcompdump file.
  #
  # References:
  # - https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Use-of-compinit
  autoload -Uz compinit
  local comp_files=($ZSH_COMPDUMP(Nmh-20))
  if (( $#comp_files )); then
    compinit -i -C -d "$ZSH_COMPDUMP"
  else
    compinit -i -d "$ZSH_COMPDUMP"
    # Ensure that $ZSH_COMPDUMP remains within the specified cache time, even if the completion
    # system is not regenerated.
    touch "$ZSH_COMPDUMP"
  fi

  # Compile zcompdump, if modified, in background to increase startup speed.
  {
    if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]; then
      if command mkdir "${ZSH_COMPDUMP}.zwc.lock" 2>/dev/null; then
        zcompile "$ZSH_COMPDUMP"
        command rmdir  "${ZSH_COMPDUMP}.zwc.lock" 2>/dev/null
      fi
    fi
  } &!
}

# Discussing compinit briefly, it operates by identifying _completion files within the fpath.
# Consequently, fpath must be fully populated before invoking compinit. However, there are
# instances where compdef needs to be called before fpath is fully populated (e.g., plugins do
# this). Compinit faces significant chicken-and-egg issues. This code addresses all completion
# use-cases by encapsulating compinit, queuing any calls to compdef, and integrating the actual
# invocation of compinit with Zephyr's custom post_zshrc event.

# Placeholder functions for compinit (compdef) are defined to queue up calls. This ensures that
# when the actual compinit is invoked, the queue can be processed.
typeset -gHa __compdef_queue=()
function compdef {
  (( $# )) || return
  local compdef_args=("${@[@]}")
  __compdef_queue+=("$(typeset -p compdef_args)")
}

# Compinit is temporarily wrapped so that when the real compinit call occurs, the queue of compdef
# calls is processed.
function compinit {
  unfunction compinit compdef &>/dev/null
  autoload -Uz compinit && compinit "$@"

  # Apply all the queued compdefs.
  local typedef_compdef_args
  for typedef_compdef_args in $__compdef_queue; do
    eval $typedef_compdef_args
    compdef "$compdef_args[@]"
  done
  unset __compdef_queue

  # Compinit may be executed at an earlier stage, thereby eliminating the necessity for a
  # post_zshrc hook.
  post_zshrc_hook=(${post_zshrc_hook:#run-compinit})
}

# compstyle-zrc-setup: Set Zsh completion styles.
#
# A composite of various other popular completion styles.
#
# Reference:
# - https://github.com/mattmc3/ez-compinit/blob/main/functions/compstyle_zshzoo_setup
function compstyle-zrc-setup {
  emulate -L zsh; setopt local_options $__zrc_opts

  # Set a reasonable default for LS_COLORS if not already set.
  export LS_COLORS="${LS_COLORS:-di=34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43}"

  # Defaults.
  # zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
  zstyle ':completion:*:default' list-prompt '%S%M matches%s'

  # Use caching to make completion for commands such as dpkg and apt usable.
  zstyle ':completion::complete:*' use-cache on
  zstyle ':completion::complete:*' cache-path "$__zsh_cache_dir/zcompcache"

  # Case-insensitive (all), partial-word, and then substring completion.
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

  # Group matches and describe.
  zstyle ':completion:*:*:*:*:*' menu select
  zstyle ':completion:*:matches' group 'yes'
  zstyle ':completion:*:options' description 'yes'
  zstyle ':completion:*:options' auto-description '%d'
  zstyle ':completion:*:corrections' format ' %F{red}-- %d (errors: %e) --%f'
  # zstyle ':completion:*:descriptions' format ' %F{purple}-- %d --%f'
  # Let fzf-tab group the results by group description.
  zstyle ':completion:*:descriptions' format '[%d]'
  zstyle ':completion:*:messages' format ' %F{green} -- %d --%f'
  zstyle ':completion:*:warnings' format ' %F{yellow}-- no matches found --%f'
  # Do not use escape sequences here, fzf-tab will ignore them.
  # zstyle ':completion:*' format ' %F{blue}-- %d --%f'
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*' verbose yes

  # Fuzzy match mistyped completions.
  zstyle ':completion:*' completer _complete _match _approximate
  zstyle ':completion:*:match:*' original only
  zstyle ':completion:*:approximate:*' max-errors 1 numeric

  # Increase the number of errors based on the length of the typed word. Make sure to cap (at 7)
  # the max-errors to avoid hanging.
  zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

  # Do not complete unavailable commands.
  zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

  # Array completion element sorting.
  zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

  # Directories
  zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
  zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
  zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
  zstyle ':completion:*' squeeze-slashes true
  zstyle ':completion:*' special-dirs ..

  # History
  zstyle ':completion:*:history-words' stop yes
  zstyle ':completion:*:history-words' remove-all-dups yes
  zstyle ':completion:*:history-words' list false
  zstyle ':completion:*:history-words' menu yes

  # Environment variables.
  zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

  # Populate hostname completion but allow ignoring custom entries from static */etc/hosts* which
  # might be uninteresting.
  zstyle -a ':zephyr:plugin:compstyle:*:hosts' etc-host-ignores '_etc_host_ignores'

  zstyle -e ':completion:*:hosts' hosts 'reply=(
    ${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
    ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%(\#${_etc_host_ignores:+|${(j:|:)~_etc_host_ignores}})*}
    ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
  )'

  # Do not complete uninteresting users...
  zstyle ':completion:*:*:*:users' ignored-patterns \
    adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
    dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
    hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
    mailman mailnull mldonkey mysql nagios \
    named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
    operator pcap postfix postgres privoxy pulse pvm quagga radvd \
    rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

  # ...unless we really want to.
  zstyle '*' single-ignored show

  # Ignore multiple entries.
  zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
  zstyle ':completion:*:rm:*' file-patterns '*:all-files'

  # Kill
  zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
  zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
  zstyle ':completion:*:*:kill:*' menu yes select
  zstyle ':completion:*:*:kill:*' force-list always
  zstyle ':completion:*:*:kill:*' insert-ids single

  # Complete manual by their section.
  zstyle ':completion:*:manuals'    separate-sections true
  zstyle ':completion:*:manuals.*'  insert-sections   true
  zstyle ':completion:*:man:*'      menu yes select

  # Complete ssh/scp/rsync.
  zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
  zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
  zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
  zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
  zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
  zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
}

#
# Initialize
#

# Set completion zstyle.
local compstyle
zstyle -s ':zrc:completion' compstyle 'compstyle' || compstyle=zrc
(( $+functions[compstyle-${compstyle}-setup] )) && compstyle-${compstyle}-setup

# Initialize completions.
# (( $+functions[compinit] )) && run-compinit

# Hook run-compinit function to the custom post_zshrc event.
post_zshrc_hook+=(run-compinit)
