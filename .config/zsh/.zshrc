#!/usr/bin/env zsh
#
#  ~/.zshrc
#             _
#     ___ ___| |_ ___ ___
#   _|- _|_ -|   |  _|  _|
#  |_|___|___|_|_|_| |___|
#
#  ~/.zshrc: Runs during interactive Zsh session.

# Enable debug output.
# set -x

# Initialize ~/.zshrc.
() {
  typeset -g ZRC_VERSION="0.0.1"
  typeset -gaH __zrc_opts=(extended_glob NO_monitor NO_xtrace NO_ksh_arrays)

  # Add variables for key Zsh directories.
  export __zsh_config_dir=${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}
  export __zsh_user_data_dir=${XDG_DATA_HOME:-$HOME/.local/share}/zsh
  export __zsh_cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/zsh

  # Define Zsh paths.
  typeset -g ZRC_{CONFIG,FUNCTION,LIB,PLUGIN,THEME}_DIR

  # Directory for configuration files. Used for plugin and application settings.
  zstyle -s ':zrc:config' dir 'ZRC_CONFIG_DIR' \
    || ZRC_CONFIG_DIR=${ZRC_CONFIG_DIR:-$__zsh_config_dir/conf.d}

  # Directory for Zsh autoload functions.
  zstyle -s ':zrc:functions' dir 'ZRC_FUNCTION_DIR' \
    || ZRC_FUNCTION_DIR=${ZRC_FUNCTION_DIR:-$__zsh_config_dir/functions}

  # Directory for additional Zsh configuration files. Used for Zsh options, features and to load
  # plugin manager.
  zstyle -s ':zrc:lib' dir 'ZRC_LIB_DIR' \
    || ZRC_LIB_DIR=${ZRC_LIB_DIR:-$__zsh_config_dir/lib}

  # Directory for Zsh plugins. Used for local (not cloned) Zsh plugins.
  zstyle -s ':zrc:plugins' dir 'ZRC_PLUGIN_DIR' \
    || ZRC_PLUGIN_DIR=${ZRC_PLUGIN_DIR:-$__zsh_config_dir/plugins}

  # Directory for Zsh prompt themes.
  zstyle -s ':zrc:themes' dir 'ZRC_THEME_DIR' \
    || ZRC_THEME_DIR=${ZRC_THEME_DIR:-$__zsh_config_dir/themes}

  # Ensure XDG/Zsh directories exist.
  () {
    local xzdir
    for xzdir in "$@"; do
        [[ -d "${(P)xzdir}" ]] || mkdir -p ${(P)xzdir}
    done
  } __zsh_{config,user_data,cache}_dir XDG_{CONFIG,CACHE,DATA,STATE,BIN}_HOME

  # Customize with zstyles.
  [[ ! -r $__zsh_config_dir/.zstyles ]] || source $__zsh_config_dir/.zstyles
}

# Source Zsh lib directory.
function zrc_lib {
  local zlibdir zfile
  zstyle -s ':zrc:lib' dir 'zlibdir' || zlibdir=$__zsh_config_dir/lib
  for zfile in $zlibdir/*.zsh(N); do
    [[ ${zfile:t} != '~'* ]] || continue
    source $zfile
  done
}

# Source Zsh plugins directory.
function zrc_plugins {
  local zplugindir zfile
  zstyle -s ':zrc:plugins' dir 'zplugindir' || zlibdir=$__zsh_config_dir/plugins
  for zfile in $zplugindir/*.zsh(N); do
    [[ ${zfile:t} != '~'* ]] || continue
    source $zfile
  done
}

# Run ~/.zshrc.
() {
  zrc_lib
  zrc_plugins
}

# Load Antidote and install plugins.
antidote load
