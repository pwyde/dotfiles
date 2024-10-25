" ~/.vim/plugins.vim
"
" Maintained by Patrik Wyde <patrik@wyde.se>
" https://github.com/pwyde

""" Plugin Manager {{{
    " Install vim-plug and plugins if missing and then quit.
    if empty(glob("$XDG_CONFIG_HOME/vim/autoload/plug.vim"))
        silent !curl -fLo $XDG_CONFIG_HOME/vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $XDG_CONFIG_HOME/vim/vimrc
    endif
    call plug#begin("$XDG_CONFIG_HOME/vim/plugged")
        Plug 'chriskempson/base16-vim'
        " Dracula theme.
        Plug 'dracula/vim', { 'as': 'dracula' }
        " Nord theme.
        Plug 'arcticicestudio/nord-vim'
        " ayu theme.
        Plug 'ayu-theme/ayu-vim'"
        " Sweet-dark theme.
        Plug 'jschmold/sweet-dark.vim'
        " Embark theme.
        Plug 'embark-theme/vim', { 'as': 'embark', 'branch': 'main' }
        " Catppuccin theme.
        Plug 'catppuccin/vim', { 'as': 'catppuccin' }
        Plug 'scrooloose/nerdtree'
        " Does not work, see reported issues below:
        "   - https://github.com/Xuyuanp/nerdtree-git-plugin/issues/121
        "   - https://github.com/Xuyuanp/nerdtree-git-plugin/pull/122
        Plug 'Xuyuanp/nerdtree-git-plugin'
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
        Plug 'dawikur/base16-vim-airline-themes'
        Plug 'ryanoasis/vim-devicons'
        Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
        Plug 'mhinz/vim-startify'
        Plug 'tpope/vim-fugitive'
        Plug 'airblade/vim-gitgutter'
        " Plugin disabled. Vim Airline seems to take care of this.
        "Plug 'bling/vim-bufferline'
        Plug 'ctrlpvim/ctrlp.vim'
        Plug 'jeffkreeftmeijer/vim-numbertoggle'
        Plug 'vim-scripts/DeleteTrailingWhitespace'
        Plug 'mrk21/yaml-vim'
    call plug#end()
""" }}}

""" nerdtree {{{
    " Map F2 => NERDTreeToggle command.
    map <F2> :NERDTreeToggle<CR>

    " Close Vim if the only window left open is NERDTree.
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " Show hidden files in NERDTree.
    let NERDTreeShowHidden=1

    " Set default directory icons (disabled for vim-devicons plugin).
    let g:NERDTreeDirArrowExpandable = '►'
    let g:NERDTreeDirArrowCollapsible = '▼'
    "let g:NERDTreeDirArrowExpandable = ' '
    "let g:NERDTreeDirArrowCollapsible = ' '
""" }}}

""" nerdtree-git-plugin {{{
    let g:NERDTreeGitStatusIndicatorMapCustom = {
        \ 'Modified'  : '*',
        \ 'Staged'    : '✚',
        \ 'Untracked' : '✭',
        \ 'Renamed'   : '➜',
        \ 'Unmerged'  : '═',
        \ 'Deleted'   : '✖',
        \ 'Dirty'     : '✗',
        \ 'Clean'     : '✔︎',
        \ 'Unknown'   : '?'
    \ }
""" }}}

""" vim-airline {{{
    " Set theme.
    "let g:airline_theme = 'ayu_dark'
    "let g:airline_theme = 'base16_tomorrow_night'
    "let g:airline_theme = 'base16_dracula'
    "let g:airline_theme = 'base16_nord'
    "let g:airline_theme = 'embark'
    let g:airline_theme = 'catppuccin_mocha'

    " Disable Powerline fonts.
    let g:airline_powerline_fonts=0

    " Display all buffers when there is only one tab open.
    let g:airline#extensions#tabline#enabled=1

    " Configure tab separators.
    let g:airline#extensions#tabline#left_sep=' '
    let g:airline#extensions#tabline#left_alt_sep='|'

    " Set path formatter in tabs.
    let g:airline#extensions#tabline#formatter='unique_tail_improved'

    " Disable collapsing of parent directories in buffer name.
    let g:airline#extensions#tabline#fnamecollapse=0

    "Display branch-indicator and branch name in status line.
    let g:airline#extensions#branch#enabled=1

    " Detect whitespace errors.
    let g:airline#extensions#whitespace#enabled=1
""" }}}

""" vim-bufferline {{{
    " Disable automatic echo to the command bar.
    let g:bufferline_echo=0
""" }}}

""" vim-devicons {{{
    " Enable folder/directory glyph.
    let g:WebDevIconsUnicodeDecorateFolderNodes=1

    " Enable open and close folder/directory glyph.
    let g:DevIconsEnableFoldersOpenClose=1
""" }}}

""" vim-nerdtree-syntax-highlight {{{
    " Hack for fixing issue with some icons that are cut off.
    " For more information, see
    " https://github.com/ryanoasis/vim-devicons/issues/133
    augroup devicons_nerdtree
        autocmd FileType nerdtree setlocal list
        autocmd FileType nerdtree setlocal listchars=space:.
        autocmd FileType nerdtree setlocal nolist
        autocmd FileType nerdtree setlocal ambiwidth=double
    augroup END

    " Highlight full name, not only icons.
    let g:NERDTreeFileExtensionHighlightFullName = 1
    let g:NERDTreeExactMatchHighlightFullName = 1
    let g:NERDTreePatternMatchHighlightFullName = 1

    " Highlight only specific extensions.
    " This is supposed to mitigate lag. For more information, see
    " https://github.com/tiagofumo/vim-nerdtree-syntax-highlight#mitigating-lag-issues
    let g:NERDTreeSyntaxDisableDefaultExtensions = 1
    let g:NERDTreeDisablePatternMatchHighlight = 1
    let g:NERDTreeSyntaxEnabledExtensions = ['conf', 'css', 'gif', 'go', 'html', 'jpg', 'js', 'json', 'markdown', 'md', 'php', 'png', 'py', 'rb', 'sh', 'vim', 'yml']
""" }}}

""" DeleteTrailingWhitespace {{{
    " Automatically delete all trailing whitespace.
    let g:DeleteTrailingWhitespace=1
    " Do not ask to delete trailing whitespace.
    let g:DeleteTrailingWhitespace_Action='delete'
""" }}}

""" yaml-vim {{{
    au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
""" }}}
