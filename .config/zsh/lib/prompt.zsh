#
# prompt.zsh - Setup Zsh prompt.
#

#
# Options
#

setopt prompt_subst       # Expand parameters in prompt variables.

# Configure a 2-space indentation for each new level in a multi-line script. This setting can
# subsequently be overridden by a prompt or plugin, but serves as a more suitable default compared
# to Zsh standard configuration.
PS2='${${${(%):-%_}//[^ ]}// /  }    '

# Set theme directory.
zstyle -s ':zrc:themes' dir 'ZRC_THEME_DIR' ||
    ZRC_THEME_DIR=$__zsh_config_dir/themes
# Make sure prompt theme path exists
[[ -d "${ZRC_THEME_DIR}" ]] || mkdir -p "${ZRC_THEME_DIR}"

#
# Functions
#

function init-prompt-starship {
  unset STARSHIP_CONFIG

  # Set the starship config based on the argument if provided.
  if [[ -n "$1" ]]; then
    local -a configs=(
      "$__zsh_config_dir/themes/${1}.toml"(N)
      "${XDG_CONFIG_HOME:-$HOME/.config}/starship/${1}.toml"(N)
      "$ZRC_THEME_DIR/${1}.toml"(N)
    )
    (( $#configs )) && export STARSHIP_CONFIG=$configs[1]
  fi

  # Initialize starship.
  source <(starship init zsh)
}

function init-prompt-omp {
  unset POSH_THEME

  # Set the oh-my-posh config based on the argument if provided.
  if [[ -n "$1" ]]; then
    local -a configs=(
      "$__zsh_config_dir/themes/${1}.omp.json"(N)
      "${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-posh/${1}.omp.json"(N)
      "$ZRC_THEME_DIR/${1}.omp.json"(N)
    )
    (( $#configs )) && export POSH_THEME=$configs[1]
  fi

  # Initialize oh-my-posh.
  eval "$(oh-my-posh init zsh)"
}

function list-themes-starship {
  # Find all .toml files in the theme directory and extract their base names (theme names).
  local -a themes
  themes=(${(f)"$(find "$ZRC_THEME_DIR" -type f -name '*.toml' -exec basename {} .toml \;)"})

  # Check if any themes were found.
  if (( $#themes == 0 )); then
    print "No Starship themes found in '$ZRC_THEME_DIR'." >&2
    return 0
  fi

  # Sort the themes alphabetically.
  themes=("${(@o)themes}")

  # Print the list of themes.
  print -P "Available Starship themes in '%F{blue}$ZRC_THEME_DIR%f':"
  for theme in $themes; do
    print "  - $theme"
  done
}

function list-themes-omp {
  # Find all .json files in the theme directory and extract their base names (theme names).
  local -a themes
  themes=(${(f)"$(find "$ZRC_THEME_DIR" -type f -name '*.json' -exec basename {} .omp.json \;)"})

  # Check if any themes were found.
  if (( $#themes == 0 )); then
    print "No Oh My Posh themes found in '$ZRC_THEME_DIR'." >&2
    return 0
  fi

  # Sort the themes alphabetically.
  themes=("${(@o)themes}")

  # Print the list of themes.
  print -P "Available Oh My Posh themes in '%F{blue}$ZRC_THEME_DIR%f':"
  for theme in $themes; do
    print "  - $theme"
  done
}

#
# Initialize
#

local -a ZRC_PROMPT_THEME
zstyle -s ':zrc:prompt' theme 'theme_string' \
  || theme_string="starship cockpit"

# Split the theme_string into an array
ZRC_PROMPT_THEME=("${(@s/ /)theme_string}")
unset theme_string

# Uncomment to debug:
# echo "ZRC_PROMPT_THEME: ${ZRC_PROMPT_THEME[@]}"

# Determine which prompt system to use and execute the appropriate setup function.
if [[ ${ZRC_PROMPT_THEME[1]} == "starship" ]]; then
  init-prompt-starship "${ZRC_PROMPT_THEME[2]}"
elif [[ ${ZRC_PROMPT_THEME[1]} == "oh-my-posh" ]]; then
  init-prompt-omp "${ZRC_PROMPT_THEME[2]}"
else
  print "Unknown prompt system: ${ZRC_PROMPT_THEME[1]}" >&2
fi
