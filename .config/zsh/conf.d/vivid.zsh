# Check if Vivid is installed.
_vivid_path=$(command -v vivid) &> /dev/null
if [[ -n "$_vivid_path" ]]; then
  # Use Vivid to set LS_COLORS.
  export LS_COLORS="$($_vivid_path generate catppuccin-mocha)"
fi
unset _vivid_path