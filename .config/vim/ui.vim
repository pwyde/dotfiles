" ~/.vim/ui.vim
"
" Maintained by Patrik Wyde <patrik@wyde.se>
" https://github.com/pwyde

""" General UI Options {{{
    " Always show cursor position.
    set ruler

    " Highlight the line currently under cursor.
    set cursorline

    " Show cursorline for active window only.
    augroup highlight_active_window
        autocmd!
        autocmd BufEnter * setlocal cursorline
        autocmd BufLeave * setlocal nocursorline
    augroup END

    " Use block cursor in normal mode and vertical bar in insert mode.
    "
    " Mode settings:
    "   'SI' : INSERT mode
    "   'SR' : REPLACE mode
    "   'EI' : NORMAL mode
    "
    " Cursor settings:
    "   '1' : Blinking block
    "   '2' : Solid block
    "   '3' : Blinking underscore
    "   '4' : Solid underscore
    "   '5' : Blinking vertical bar
    "   '6' : Solid vertical bar
    "
    " For more information, see https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"

    " Enable mouse support.
    set mouse=a

    " Show hybrid line number on the sidebar.
    set number relativenumber

    " Disable the default mode indicator (disabled for vim-airline plugin).
    set noshowmode

    " Set custom status line if vim-airline is not available.
    set statusline=%1*%{winnr()}\ %*%<\ %f\ %h%m%r%=%l,%c%V\ (%P)

    " Always display the status line.
    set laststatus=2
""" }}}

""" Completion Options {{{
    " Display command line tab complete options as a menu.
    set wildmenu

    " Display incomplete commands.
    set showcmd

    " Complete only until point of ambiguity.
    "set wildmode=list:longest
""" }}}

""" Split Options {{{
    " Splits open at bottom and right.
    set splitbelow splitright
""" }}}

""" Tab Panel Options {{{
    " Always show tab panel.
    set showtabline=2

    " Maximum number of tab pages that can be opened from the command line.
    "set tabpagemax=20
""" }}}

""" Window Options {{{
    " Set the windows title, reflecting the file currently being edited.
    set title

    " Use colors for dark backgrounds.
    set background=dark

    " Disable blinking.
    set novisualbell

    " Disable beep on errors.
    set noerrorbells

    " Display a confirmation dialog when closing/switching an un-
    " saved file/buffer.
    "set confirm

    " Hide files/buffers in the background instead of closing them.
    set hidden
""" }}}

""" Search Options {{{
    " Enable search highlighting.
    set hlsearch

    " Ignore case when searching.
    set ignorecase

    " Automatically switch search to case-sensitive when search query contains an
    " uppercase letter.
    set smartcase

    " Incremental search that shows partial matches.
    set incsearch
""" }}}

""" Theme Options {{{
    " Use 24-bit colors.
    set termguicolors

    " Set color scheme and silence errors if scheme does not exist.
    " Official ayu theme.
    "let ayucolor="light"  " Light version of ayu theme.
    "let ayucolor="mirage" " Mirage version of ayu theme.
    "let ayucolor="dark"   " Dark version of ayu theme.
    "silent! colorscheme ayu
    " Tomorrow Night theme from Base16.
    "silent! colorscheme base16-tomorrow-night
    " Official Dracula theme.
    "silent! colorscheme dracula
    " Official Nord theme.
    silent! colorscheme nord
    " Sweet-dark theme.
    "silent! colorscheme sweet_dark
    " Embark theme.
    "silent! colorscheme embark
""" }}}

""" gVim Options {{{
    set guifont=SauceCodePro\ Nerd\ Font
""" }}}
