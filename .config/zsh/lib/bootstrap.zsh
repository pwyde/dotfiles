#
# bootstrap.zsh - Bootstrap Zsh environment.
#

# Set critical Zsh options.
setopt extended_glob interactive_comments

# A post_zshrc event does not inherently exist; therefore, a simulated event is created by
# incorporating a function named run_post_zshrc into the precmd event. This function executes only
# once and subsequently deregisters itself. If desired or required due to compatibility issues with
# a plugin, the function can be manually invoked at the conclusion of the .zshrc file, followed by
# the deregistration of the precmd event.

# Define a variable to store actions executed during the post_zshrc event.
typeset -ga post_zshrc_hook

# The new event is added.
function run_post_zshrc {
  # Any actions attached to the post_zshrc hook are executed.
  local fn
  for fn in $post_zshrc_hook; do
    # Uncomment to debug:
    # echo "post_zshrc is about to run: ${=fn}"
    "${=fn}"
  done

  # The precmd hook is then deleted, and the function along with its associated list variable is
  # removed to ensure it runs only once and does not continue executing on future precmd events.
  add-zsh-hook -d precmd run_post_zshrc
  unfunction -- run_post_zshrc
  unset -- post_zshrc_hook
}

# The run_post_zshrc function is attached to the built-in precmd.
autoload -U add-zsh-hook
add-zsh-hook precmd run_post_zshrc
