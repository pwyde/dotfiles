#
# plugins.zsh - Small and simple custom Zsh plugin manager.
#

# References:
# - https://github.com/mattmc3/zsh_unplugged/blob/main/antidote.lite.zsh
# - https://github.com/mattmc3/zshrc1/blob/main/.zshrc1

# Example to include in ~/.zshrc:
#
# # Prompt (fpath) plugins.
# zrc_prompts=(
#   sindresorhus/pure
#   romkatv/powerlevel10k
# )

# # Regular Zsh plugins.
# zrc_plugins=(
#   $ZRC_PLUGIN_DIR/*.plugin.zsh
#   ohmyzsh/ohmyzsh/plugins/command-not-found
#   ohmyzsh/ohmyzsh/plugins/eza
#   ohmyzsh/ohmyzsh/plugins/debian
#   ohmyzsh/ohmyzsh/plugins/extract
#   ohmyzsh/ohmyzsh/plugins/fluxcd
#   ohmyzsh/ohmyzsh/plugins/git
#   ohmyzsh/ohmyzsh/plugins/gpg-agent
#   ohmyzsh/ohmyzsh/plugins/helm
#   ohmyzsh/ohmyzsh/plugins/k9s
#   ohmyzsh/ohmyzsh/plugins/kubectl
#   ohmyzsh/ohmyzsh/plugins/ubuntu
#   djui/alias-tips
#   unixorn/fzf-zsh-plugin

#   # Completions
#   luoxu34/zfs-completion
#   zsh-users/zsh-completions

#   # Deferred plugins may speed up load times.
#   # Once romkatv/zsh-defer is loaded, remaining plugins in the array are deferred.
#   romkatv/zsh-defer
#   olets/zsh-abbr
#   zdharma-continuum/fast-syntax-highlighting
#   zsh-users/zsh-autosuggestions
#   zsh-users/zsh-history-substring-search
# )

# plugin-clone $zrc_prompts $zrc_plugins
# plugin-load --kind fpath $zrc_prompts
# plugin-load $zrc_plugins

# Set variables.
: ${PLUGIN_REPO_DIR:=${XDG_CACHE_HOME:-~/.cache}/zsh/plugins}
: ${ZRC_PLUGIN_DIR:=${ZSH_CUSTOM:-${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}}/plugins}
typeset -gHa __zplug_opts=(extended_glob glob_dots no_monitor)

# Clone Zsh plugins in parallel.
function plugin-clone {
  emulate -L zsh; setopt local_options $__zplug_opts
  local repo plugdir; local -Ua repos

  # Remove bare words ${(M)@:#*/*} and paths with leading slash ${@:#/*}.
  # Then split/join to keep the 2-part user/repo form to bulk-clone repos.
  for repo in ${${(M)@:#*/*}:#/*}; do
    repo=${(@j:/:)${(@s:/:)repo}[1,2]}
    [[ -e $PLUGIN_REPO_DIR/$repo ]] || repos+=$repo
  done

  for repo in $repos; do
    plugdir=$PLUGIN_REPO_DIR/$repo
    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      (
        command git clone -q --depth 1 --recursive --shallow-submodules \
          ${GITHUB_URL:-https://github.com/}$repo $plugdir
        plugin-compile $plugdir
      ) &
    fi
  done
  wait
}

# Load Zsh plugins.
function plugin-load {
  source <(plugin-script $@)
}

# Script loading of Zsh plugins.
function plugin-script {
  emulate -L zsh; setopt local_options $__zplug_opts

  # Parse args.
  local kind  # kind=path,fpath
  while (( $# )); do
    case $1 in
      -k|--kind)  shift; kind=$1 ;;
      -*)         echo >&2 "Invalid argument '$1'." && return 2 ;;
      *)          break ;;
    esac
    shift
  done

  local plugin src="source" inits=()
  (( ! $+functions[zsh-defer] )) || src="zsh-defer ."
  for plugin in $@; do
    if [[ -n "$kind" ]]; then
      echo "$kind=(\$$kind $PLUGIN_REPO_DIR/$plugin)"
    else
      inits=(
        {$ZRC_PLUGIN_DIR,$PLUGIN_REPO_DIR}/$plugin/${plugin:t}.{plugin.zsh,zsh-theme,zsh,sh}(N)
        $PLUGIN_REPO_DIR/$plugin/*.{plugin.zsh,zsh-theme,zsh,sh}(N)
        $PLUGIN_REPO_DIR/$plugin(N)
        ${plugin}/*.{plugin.zsh,zsh-theme,zsh,sh}(N)
        ${plugin}(N)
      )
      (( $#inits )) || { echo >&2 "No plugin init found '$plugin'." && continue }
      plugin=$inits[1]
      echo "fpath=(\$fpath $plugin:h)"
      echo "$src $plugin"
      [[ "$plugin:h:t" == zsh-defer ]] && src="zsh-defer ."
    fi
  done
}

# Update plugins.
function plugin-update {
  emulate -L zsh; setopt local_options $__zplug_opts
  local plugdir oldsha newsha
  for plugdir in $PLUGIN_REPO_DIR/*/*/.git(N/); do
    plugdir=${plugdir:A:h}
    echo "Updating ${plugdir:h:t}/${plugdir:t}..."
    (
      oldsha=$(command git -C $plugdir rev-parse --short HEAD)
      command git -C $plugdir pull --quiet --ff --depth 1 --rebase --autostash
      newsha=$(command git -C $plugdir rev-parse --short HEAD)
      [[ $oldsha == $newsha ]] || echo "Plugin updated: $plugdir:t ($oldsha -> $newsha)"
    ) &
  done
  wait
  plugin-compile
  echo "Update complete."
}

# Compile plugins.
function plugin-compile {
  emulate -L zsh; setopt local_options $__zplug_opts
  autoload -Uz zrecompile
  local zfile
  for zfile in ${1:-$PLUGIN_REPO_DIR}/**/*.zsh{,-theme}(N); do
    [[ $zfile != */test-data/* ]] || continue
    zrecompile -pq "$zfile"
  done
}

# Show the plugin repo directory.
function plugin-repo {
  emulate -L zsh; setopt local_options $__zplug_opts
  print -r -- $PLUGIN_REPO_DIR
}

# Show the plugin home directory.
function plugin-home {
  emulate -L zsh; setopt local_options $__zplug_opts
  print -r -- $ZRC_PLUGIN_DIR
}

# List cloned plugins.
function plugin-list {
  emulate -L zsh; setopt local_options $__zplug_opts
  local plugin_dir
  for plugin_dir in $PLUGIN_REPO_DIR/**/*/.git(N/); do
    print -r -- ${plugin_dir:A:h:t}
  done
}
