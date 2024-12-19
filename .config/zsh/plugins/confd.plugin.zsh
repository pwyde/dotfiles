#
# confd.plugin.zsh - Use a Fish-like conf.d directory for sourcing configuration files.
#

# Set $0.
0=${(%):-%N}

typeset -ga _confd=(
  $ZRC_CONFIG_DIR
  ${ZDOTDIR:-/dev/null}/conf.d(N)
  ${ZDOTDIR:-/dev/null}/rc.d(N)
  ${ZDOTDIR:-/dev/null}/zshrc.d(N)
  ${ZDOTDIR:-$HOME}/.zshrc.d(N)
)
if [[ ! -e "$_confd[1]" ]]; then
  echo >&2 "confd: Directory not found '${ZRC_CONFIG_DIR:-${ZDOTDIR:-$HOME}/conf.d}'."
  return 1
fi

typeset -ga _confd=("$_confd[1]"/*.{sh,zsh}(N))
typeset -g _confd_file
for _confd_file in ${(o)_confd}; do
  [[ ${_confd_file:t} != '~'* ]] || continue  # Ignore tilde files.
  source "$_confd_file"
done
unset _confd{,_file}
