" ~/.vim/general.vim
"
" Maintained by Patrik Wyde <patrik@wyde.se>
" https://github.com/pwyde

""" General Options {{{
    " Disable compability with Vi.
    set nocompatible

    " Set Vim path.
    set runtimepath=$XDG_CONFIG_HOME/vim,$VIMRUNTIME,$XDG_CONFIG_HOME/vim/after

    " Set default shell for executing commands.
    set shell=/bin/zsh

    " Set viminfo location.
    set viminfo+='1000,n$XDG_DATA_HOME/vim/viminfo

    " Increase history from the default (20) to 500.
    set history=500

    " Time to wait after ESC (default causes an delay).
    set timeoutlen=250

    " Set update interval (lowered for vim-gitgutter plugin).
    set updatetime=100
""" }}}

""" Backup & Swap Options {{{
    " Disable backup and swap files.
    "set noswapfile
    "set nobackup

    " Configure directory for backup.
    set backupdir=$XDG_DATA_HOME/vim/backup
    if isdirectory(&backupdir)==0
        " Create backup directory.
        call system('mkdir ' . &backupdir)
    endif

    " Configure directory for swap.
    set directory=$XDG_DATA_HOME/vim/swap
    if isdirectory(&directory)==0
        " Create swap directory.
        call system('mkdir ' . &directory)
    endif

    " Set persistent undo history between sessions.
    set undofile

    " Set maximum number of changes that can be undone.
    set undolevels=100

    " Configure directory to save undo history.
    if has('persistent_undo')
        set undodir=$XDG_DATA_HOME/vim/undo
        if isdirectory(&undodir)==0
            " Create undo directory.
            call system('mkdir ' . &undodir)
        endif
    endif

    " Configure directory for view.
    set viewdir=$XDG_DATA_HOME/vim/view
    if isdirectory(&viewdir)==0
        " Create view directory.
        call system('mkdir ' . &viewdir)
    endif

    " Don not create backups in directories below.
    set backupskip=/tmp/*
""" }}}

""" Encoding Options {{{
    " Use an encoding that supports unicode.
    set encoding=utf-8
    set fileencodings=utf-8
""" }}}

""" Text Rendering Options {{{
    " Enable line wrapping.
    set wrap

    " Avoid wrapping a line in the middle of a word.
    set linebreak

    " The number of screen lines to keep above and below the cursor.
    set scrolloff=5

    " The number of screen columns to keep to the left and right of the cursor.
    set sidescrolloff=5

    " Enable syntax highlighting.
    filetype plugin on
    syntax on
""" }}}

""" Code Folding Options {{{
    " Enable folding.
    set foldenable

    " Fold based on indention levels.
    set foldmethod=indent

    " Disable auto-folding.
    set foldlevel=99

    " Set max folding level.
    set foldnestmax=3
""" }}}

""" Formatting Options {{{
    " New lines inherit the indentation of previous lines.
    set autoindent

    " Set smart autoindenting when starting a new line.
    set smartindent

    " Enable indentation rules that are file-type specific.
    filetype indent on

    " Set default tabstop.
    set tabstop=4
    set softtabstop=4

    " Set the default shift width for indents.
    set shiftwidth=4

    " Convert tabs to spaces.
    set expandtab

    " Set smart tab levels.
    set smarttab

    " Disable automatic commenting on newline.
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

    " Disabled. DeleteTrailingWhitespace plugin takes care of this.
    " Automatically delete all trailing whitespeace on save.
    "autocmd BufWritePre * %s/\s\+$//e
""" }}}
