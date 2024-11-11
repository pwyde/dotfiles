#!/usr/bin/env zsh

################################################################################
#  CONFIGURE KEY BINDINGS
################################################################################

# Key bindings and configuration based on Roman Perepelitsa's dotfiles;
# https://github.com/romkatv/dotfiles-public/blob/master/dotfiles/bindings.zsh

() {
    autoload -U edit-command-line up-line-or-beginning-search down-line-or-beginning-search

    zle -N edit-command-line
    zle -N expand-or-complete-with-dots
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search

    if (( $+terminfo[smkx] && $+terminfo[rmkx] )); then
        enable-term-application-mode() {
            echoti smkx
        }
        disable-term-application-mode() {
            echoti rmkx
        }
        autoload -Uz add-zle-hook-widget
        zle -N enable-term-application-mode
        zle -N disable-term-application-mode
        add-zle-hook-widget line-init enable-term-application-mode
        add-zle-hook-widget line-finish disable-term-application-mode
    fi

    local -A key_code=(
        Ctrl          '^'
        CtrlDel       '\e[3;5~'
        CtrlBackspace '^H'
        CtrlUp        '\e[1;5A'
        CtrlDown      '\e[1;5B'
        CtrlRight     '\e[1;5C'
        CtrlLeft      '\e[1;5D'
        AltUp         '\e[1;3A'
        AltDown       '\e[1;3B'
        AltRight      '\e[1;3C'
        AltLeft       '\e[1;3D'
        Alt           '\e'
        Tab           '\t'
        Backspace     '^?'
        Delete        '\e[3~'
        Insert        "$terminfo[kich1]"
        Home          "$terminfo[khome]"
        End           "$terminfo[kend]"
        PageUp        "$terminfo[kpp]"
        PageDown      "$terminfo[knp]"
        Up            "$terminfo[kcuu1]"
        Left          "$terminfo[kcub1]"
        Down          "$terminfo[kcud1]"
        Right         "$terminfo[kcuf1]"
        ShiftTab      "$terminfo[kcbt]"
    )

    bindings=(
        Backspace       backward-delete-char                # Delete one char backward.
        Delete          delete-char                         # Delete one char forward.
        Home            beginning-of-line                   # Go to the beginning of line.
        End             end-of-line                         # Go to the end of line.
        CtrlRight       forward-word                        # Go forward one word.
        CtrlLeft        backward-word                       # Go backward one word.
        CtrlBackspace   backward-kill-word                  # Delete previous word.
        CtrlDel         kill-word                           # Delete next word.
        Ctrl-J          backward-kill-line                  # Delete everything before cursor.
        Ctrl-Z          undo                                # Undo (suspend is on Ctrl-B).
        Alt-Z           redo                                # Redo
        Left            backward-char                       # Move cursor one character backward.
        Right           forward-char                        # Move cursor one character forward.
        Up              up-line-or-beginning-search         # Previous command in history.
        Down            down-line-or-beginning-search       # Next command in history.
        CtrlUp          history-substring-search-up         # Search for previous command in history (zsh-history-substring-search)
        CtrlDown        history-substring-search-down       # Search for next command in history (zsh-history-substring-search).
        ShiftTab        reverse-menu-complete               # Previous selection in completion menu.
        Ctrl-E          edit-command-line                   # Edit command in $EDITOR.
      # Disabled because an extra dash (-) is displayed after '...' while completing.
      # Tab             expand-or-complete-with-dots        # Show '...' while completing.
      # Disabled due to issue with fast-syntax-highlighting plugin.
      # Keyboard shortcuts specified below are plugin default.
      # AltUp           dirhistory_zle_dirhistory_up        # Change to parent directory.
      # AltDown         dirhistory_zle_dirhistory_down      # Change directory into the first sub-directory.
      # AltRight        dirhistory_zle_dirhistory_future    # Change directory history forward.
      # AltLeft         dirhistory_zle_dirhistory_back      # Change directory history backward.
        Alt-k           vi-backward-kill-word               # Delete previous word in Vim-style.
    )

    local key widget
    for key widget in $bindings[@]; do
        local -a code=('')
        local part=''
        for part in ${(@ps:-:)key}; do
            if [[ $#part == 1 ]]; then
                code=${^code}${(L)part}
            elif [[ -n $key_code[$part] ]]; then
                local -a p=(${(@ps: :)key_code[$part]})
                code=(${^code}${^p})
            else
                (( $+key_code[$part] )) || print -P "%F{red}[ERROR]%f Undefined key: $part" >&2
                code=()
                break
            fi
        done
        local c=''
        for c in $code[@]; do
            bindkey $c $widget
        done
    done
    
    zsh-list-keybindings() {
        print ""
        print -P "%BConfigured key bindings%b"
        local key binding
        for key binding in $bindings[@]; do
            print -P "  %B- %F{cyan}$key%f%b %F{yellow}$binding%f"
        done
        print ""
    }

    expand-or-complete-with-dots() {
        emulate -L zsh
        local c=$(( ${+terminfo[rmam]} && ${+terminfo[smam]} ))
        (( c )) && echoti rmam
        print -Pn "%{%F{red}......%f%}"
        (( c )) && echoti smam
        zle expand-or-complete
        zle redisplay
    }
}
