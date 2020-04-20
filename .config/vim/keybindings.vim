" ~/.vim/keybindings.vim
"
" Maintained by Patrik Wyde <patrik@wyde.se>
" https://github.com/pwyde

""" Key Bindings {{{
    " Requires gVim!!!
    " Map Ctrl+C => copy to the system clipboard (+).
    "vnoremap <C-c> "+y

    " Requires gVim!!!
    " Map Ctrl+C => copy to both the system clipboard (+) and primary
    " selection (*).
    vnoremap <C-c> "*y :let @+=@*<CR>

    " Map Ctrl+V => paste from system clipboard.
    map <C-v> "+P

    " Map keys for split navigation and saving a keypress.
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l

    " Map keys for buffer navigation.
    noremap <C-Right> :bnext<CR>
    noremap <C-Left> :bprev<CR>

    " Map keys for tab naviigation.
    nnoremap <Tab><Left> :tabprevious<CR>
    nnoremap <Tab><Right> :tabnext<CR>
    " Map keys for tab movement.
    nnoremap <silent> <Tab><A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
    nnoremap <silent> <Tab><A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

    " Map Space => open/close code folds.
    nnoremap <space> za

    " Disable the last highlighted search pattern with return key.
    nnoremap <CR> :noh<CR><CR>

    " Map \+S => check file with shellcheck.
    map <leader>s :!clear && shellcheck %<CR>
""" }}}
