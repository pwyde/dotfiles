# Determine if fzf is already installed using package manager.
if [[ $(command -v fzf) == /usr/bin/fzf ]]; then
  FZF_PATH="$XDG_DATA_HOME/fzf"
  # Source fzf completion and key bindings provided by package manager.
  source /usr/share/fzf/completion.zsh
  source /usr/share/fzf/key-bindings.zsh
else
  # Let fzf-zsh-plugin handle installation of fzf instead.
  FZF_PATH="$XDG_DATA_HOME/fzf"
fi
FZF_COLOR_SCHEME="--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
                  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
                  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
                  --color=selected-bg:#45475a"
FZF_DEFAULT_OPTS="--layout=reverse \
                  --info=inline \
                  --height=80% \
                  --multi \
                  --preview='([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2>/dev/null | head -n 200' \
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
                  --bind '?:toggle-preview' \
                  --bind 'ctrl-a:select-all' \
                  --bind 'ctrl-e:execute(vim {+} >/dev/tty)' \
                  --bind 'ctrl-v:execute(code {+})'"
FZF_PREVIEW_WINDOW=":right"
