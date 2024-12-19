#
# directory.zsh - Set features related to Zsh directories and dirstack.
#

#
# Options
#

# Set Zsh options related to directories, globbing, and I/O.
setopt auto_pushd         # Make cd push the old directory onto the dirstack.
setopt pushd_minus        # Exchanges meanings of +/- when navigating the dirstack.
setopt pushd_silent       # Do not print the directory stack after pushd or popd.
setopt pushd_to_home      # Push to home directory when no argument is given.
setopt multios            # Write to multiple descriptors.
setopt extended_glob      # Use extended globbing syntax (#,~,^).
setopt glob_dots          # Don not hide dotfiles from glob patterns.
setopt NO_clobber         # Don not overwrite files with >. Use >| to bypass.
setopt NO_rm_star_silent  # Ask for confirmation for 'rm *' or 'rm path/*'.

#
# Aliases
#

# Set directory aliases.
alias dirh='dirs -v'

#
# Functions
#

# Quickly go up any number of directories.
function up {
  local parents="${1:-1}"
  if [[ ! "$parents" -gt 0 ]]; then
    echo >&2 "Usage: up [<num>]"
    return 1
  fi
  local dotdots=".."
  while (( --parents )); do
    dotdots+="/.."
  done
  cd "$dotdots"
}
