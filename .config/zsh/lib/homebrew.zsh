#
# homebrew.zsh - Environment variables and functions for Homebrew.
#

# References:
# - https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/brew
# - https://github.com/sorin-ionescu/prezto/tree/master/modules/homebrew

# Setup Homebrew if it exists on the system.
typeset -aU _brewcmd=(
  $commands[brew]
  /home/linuxbrew/.linuxbrew/bin/brew(N)
  $HOME/.homebrew/bin/brew(N)
  $HOME/.linuxbrew/bin/brew(N)
  /opt/homebrew/bin/brew(N)
  /usr/local/bin/brew(N)
)
(( ${#_brewcmd} ))

# Use Homebrew if it exists on the system.
if [[ ${#_brewcmd} != 0 ]]; then
  # Homebrew shellenv.
  if zstyle -t ':zrc:homebrew' 'use-cache'; then
    cached-eval 'brew_shellenv' $_brewcmd[1] shellenv
  else
    source <($_brewcmd[1] shellenv)
  fi
  unset _brewcmd

  # Ensure user bins preceed homebrew in path.
  path=($prepath $path)

  # Disable Homebrew analytics.
  HOMEBREW_NO_ANALYTICS=${HOMEBREW_NO_ANALYTICS:-1}

  # Add brewed Zsh to fpath.
  if [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
    fpath+=("$HOMEBREW_PREFIX/share/zsh/site-functions")
  fi

  # Add keg-only completions to fpath.
  zstyle -a ':zrc:homebrew' 'keg-only-brews' '_kegonly' \
    || _kegonly=(curl ruby sqlite)
  for _keg in $_kegonly; do
    fpath=($HOMEBREW_PREFIX/opt/${_keg}/share/zsh/site-functions(/N) $fpath)
  done
  unset _keg{,only}

  # Set aliases.
  if ! zstyle -t ':zrc:homebrew:alias' skip; then
    alias brewup="brew update && brew upgrade && brew cleanup"
    alias brewinfo="brew leaves | xargs brew desc --eval-all"

    brewdeps() {
      emulate -L zsh; setopt local_options
      local bluify_deps='
        BEGIN { blue = "\033[34m"; reset = "\033[0m" }
              { leaf = $1; $1 = ""; printf "%s%s%s%s\n", leaf, blue, $0, reset}
      '
      brew leaves | xargs brew deps --installed --for-each | awk "$bluify_deps"
    }
  fi
fi
