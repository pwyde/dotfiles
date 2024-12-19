# Preview directory content with eza when completing cd.
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -hl --git --color=always --icons $realpath'
zstyle ':fzf-tab:*'             fzf-flags   --color="bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8" \
                                            --color="fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc" \
                                            --color="marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8" \
                                            --color="selected-bg:#45475a" \
                                            --layout=reverse \
                                            --info=inline \
                                            --height=50% \
                                            --multi \
                                            --preview-window="border-sharp" \
                                            --bind "?:toggle-preview" \
                                            --bind "ctrl-a:select-all" \
                                            --bind "ctrl-e:execute(vim {+} >/dev/tty)" \
                                            --bind "ctrl-v:execute(code {+})"
