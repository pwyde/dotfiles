# Define the cache directory.
_bat_cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/bat
# Check if the cache directory exists.
if [[ ! -d "$_bat_cache_dir" ]]; then
  # Create the cache directory if it does not exist.
  mkdir -p "$_bat_cache_dir"
  # Execute the command to build the cache.
  $(which bat) cache --build
fi
unset _bat_cache_dir

alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'