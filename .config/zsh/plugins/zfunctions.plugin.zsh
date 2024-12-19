#
# zfunctions.plugin.zsh - Use functions directory to store lazy-loaded Zsh function files.
#

# Set $0.
0=${(%):-%N}

##? autoload-dir - Autoload function files in directory.
function autoload-dir {
  local zdir
  local -a zautoloads
  for zdir in $@; do
    [[ -d "$zdir" ]] || continue
    fpath=("$zdir" $fpath)
    zautoloads=($zdir/*~_*(N.:t))
    (( $#zautoloads > 0 )) && autoload -Uz $zautoloads
  done
}

##? funcsave - Save a function.
function funcsave {
  emulate -L zsh; setopt local_options
  : ${ZRC_FUNCTION_DIR:=$__zsh_config_dir/functions}

  # check args
  if (( $# == 0 )); then
    echo >&2 "funcsave: Expected at least 1 args, got only 0."
    return 1
  elif ! typeset -f "$1" > /dev/null; then
    echo >&2 "funcsave: Unknown function '$1'."
    return 1
  elif [[ ! -d "$ZRC_FUNCTION_DIR" ]]; then
    echo >&2 "funcsave: Directory not found '$ZRC_FUNCTION_DIR'."
    return 1
  fi

  # Make sure the function is loaded in case it is already lazy-loaded.
  autoload +X "$1" > /dev/null

  # Remove first/last lines (ie: 'function foo {' and '}') and de-indent one level.
  type -f "$1" | awk 'NR>2 {print prev} {gsub(/^\t/, "", $0); prev=$0}' >| "$ZRC_FUNCTION_DIR/$1"
}

##? funced - Edit the function specified.
function funced {
  emulate -L zsh; setopt local_options
  : ${ZRC_FUNCTION_DIR:=$__zsh_config_dir/functions}

  # Check args.
  if (( $# == 0 )); then
    echo >&2 "funced: Expected at least 1 args, got only 0."
    return 1
  elif [[ ! -d "$ZRC_FUNCTION_DIR" ]]; then
    echo >&2 "funced: Directory not found '$ZRC_FUNCTION_DIR'."
    return 1
  fi

  # New function definition: make a file template
  if [[ ! -f "$ZRC_FUNCTION_DIR/$1" ]]; then
    local -a funcstub
    funcstub=(
      "#\!/bin/zsh"
      "#function $1 {"
      ""
      "#}"
      "#$1 \"\$@\""
    )
    printf '%s\n' "${funcstub[@]}" > "$ZRC_FUNCTION_DIR/$1"
    autoload -Uz "$ZRC_FUNCTION_DIR/$1"
  fi

  # Open the function file.
  if [[ -n "$VISUAL" ]]; then
    $VISUAL "$ZRC_FUNCTION_DIR/$1"
  else
    ${EDITOR:-vim} "$ZRC_FUNCTION_DIR/$1"
  fi
}

##? funcfresh - Reload an autoload function.
function funcfresh {
  if (( $# == 0 )); then
    echo >&2 "funcfresh: Expecting function argument."
    return 1
  elif ! (( $+functions[$1] )); then
    echo >&2 "funcfresh: Function not found '$1'."
    return 1
  fi
  unfunction $1
  autoload -Uz $1
}

# Set ZRC_FUNCTION_DIR.
if [[ -z "$ZRC_FUNCTION_DIR" ]]; then
  ZRC_FUNCTION_DIR="$__zsh_config_dir/functions"
  ZRC_FUNCTION_DIR="${~ZRC_FUNCTION_DIR}"
fi

# Autoload ZRC_FUNCTION_DIR.
if [[ -d "$ZRC_FUNCTION_DIR" ]]; then
  autoload-dir $ZRC_FUNCTION_DIR(N/) $ZRC_FUNCTION_DIR/*(N/)
fi
