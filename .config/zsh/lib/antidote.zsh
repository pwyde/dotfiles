#
# antidote.zsh - Install and initialize Zsh plugin manager.
#

# Setup Antidote.
export ANTIDOTE_HOME=${ANTIDOTE_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/antidote}
zstyle -s ':antidote:home' dir 'antidote_dir' \
  || antidote_dir=$ANTIDOTE_HOME

# Clone Antidote if missing.
[[ -d $antidote_dir ]] \
  || git clone --depth 1 --quiet https://github.com/mattmc3/antidote $antidote_dir

# Lazy-load Antidote from its functions directory.
fpath=($antidote_dir/functions $fpath)
autoload -Uz antidote
