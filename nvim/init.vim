call plug#begin('~/.config/nvim/plugins')

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'preservim/nerdtree' " File Explorer
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy Search
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'jiangmiao/auto-pairs' " Auto Close Bracket

Plug 'HerringtonDarkholme/yats.vim' " TS Syntax

" Git Stuff
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'

" Themes
Plug 'nanotech/jellybeans.vim'
Plug 'morhetz/gruvbox'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" Enable Themes
" colorscheme gruvbox
colorscheme jellybeans

" Line Numbers
set number

" Function to check if NerdTree is open
fun! IsNERDTreeOpen()
	return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfun

fun! NerdTreeLogic()
	if IsNERDTreeOpen()
		NERDTreeFocus
	else
		NERDTreeToggle
	endif
endfun

" Keybinds
nnoremap <C-e> :call NerdTreeLogic()<CR>

" Open Terminal Keybind
" Steps:
"  Split window horizontally
"  Move focus one window down
"  Open a terminal in the current window
"  Resize the current window to be 8 rows in height
"  Disable line numbers
"  Enter insert mode
nnoremap <C-q> <C-W>s <C-W>j :term<CR> 8<C-W>- :set nu!<CR> i

fun! Start()
    " Don't run if: we have command line arguments, we don't have an empty
    " buffer, if we've not invoked as vim or gvim, or if we start in insert mode
    if argc() || line2byte('$') != -1 || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
        return
    endif

    enew " New buffer

    " Buffer options
    setlocal
    	\ bufhidden=wipe
        \ buftype=nofile
        \ nobuflisted
        \ nocursorcolumn
        \ nocursorline
        \ nolist
        \ nonumber
        \ noswapfile
        \ norelativenumber

    " Write message to buffer
    call append('$', "NeoVim")

    " Disallow modifications
    setlocal nomodifiable nomodified

    " When insert mode is entered, start a new buffer
    nnoremap <buffer><silent> e :enew<CR>
    nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
    nnoremap <buffer><silent> o :enew <bar> startinsert<CR>
endfun

autocmd VimEnter * call Start()

set mouse=a

" Powerline customizations
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='jellybeans'

" Ctags extras
" Open definition in new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" Open definition in vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

map <Up> :resize +2<CR>
map <Down> :resize -2<CR>
map <Left> :vertical resize +2<CR>
map <Right> :vertical resize -2<CR>

let mapleader = ","

" Clipboard Copy and Paste
vmap <leader>y "+y
vmap <leader>p "+p

" map <leader>v :echo "hi"<CR>

" Spell Checking
" ]s jump to next misspelled word
" [s jump to previous misspelled word
" z= to see possible corrections
" zg to mark word as correct and add to dictionary
" zw to make word as incorrect
map <leader>s :set spell spelllang=en_us<CR>
map <leader>d :set nospell<CR>

" Key maps inside inset mode
imap jk <Esc>

augroup ScrollbarInit
  autocmd!
  autocmd CursorMoved,VimResized,QuitPre * silent! lua require('scrollbar').show()
  autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
  autocmd WinLeave,BufLeave,BufWinLeave,FocusLost            * silent! lua require('scrollbar').clear()
augroup end
