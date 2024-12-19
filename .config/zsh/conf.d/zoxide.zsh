# Check if Zoxide is installed.
_zoxide_path=$(command -v zoxide) &> /dev/null
if [[ -n "$_zoxide_path" ]]; then
  # Initialize.
  eval "$($_zoxide_path init zsh)"
fi
unset _zoxide_path

export _ZO_FZF_OPTS="--layout=reverse \
                     --info=inline \
                     --height=80% \
                     --multi \
                     --preview='eza -hl --git --color=always --icons {2..}' \
                     --preview-window=':right' \
                     --preview-window="border-sharp" \
                     --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
                     --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
                     --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
                     --color=selected-bg:#45475a \
                     --bind 'ctrl-space:toggle' \
                     --bind 'tab:down' \
                     --bind 'btab:up' \
                     --bind 'change:top' \
                     --bind '?:toggle-preview'"