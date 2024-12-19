if [[ $(command -v fzf) == /usr/bin/fzf ]]; then
  # Auto-completion
  source /usr/share/fzf/completion.zsh
  # Key bindings
  source /usr/share/fzf/key-bindings.zsh
else
  # Setup fzf
  if [[ ! "$PATH" == *${FZF_PATH}/bin* ]]; then
    export PATH="$PATH:${FZF_PATH}/bin"
  fi
  # Auto-completion
  [[ $- == *i* ]] && source "${FZF_PATH}/shell/completion.zsh" 2> /dev/null
  # Key bindings
  source "${FZF_PATH}/shell/key-bindings.zsh"
fi