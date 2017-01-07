" reload vimrc :so % 

call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
" Plug 'junegunn/seoul256.vim'
" Plug 'junegunn/vim-easy-align'
"
" " On-demand loading
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
"
" " Using git URL
" Plug 'https://github.com/junegunn/vim-github-dashboard.git'
"
" " Plugin options
" Plug 'nsf/gocode', { 'tag': 'go.weekly.2012-03-13', 'rtp': 'vim' }
"
" " Plugin outside ~/.vim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
"
" " Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'

"Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-vinegar'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }

call plug#end()

set number
set formatoptions+=t
"set tw=79
set t_Co=256
colors wombat256mod
set colorcolumn=+1
hi ColorColumn ctermbg=235
set statusline=%<%{fugitive#statusline()}%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

set tabstop=4
set shiftwidth=4
set expandtab

"---Experimental---"
set nowrap
set mouse=a
set hlsearch
set showmode
set hid

"---Mappings---"
let mapleader = ','

" Wrapped lines goes down/up to next row, rather than next line in file
nnoremap j gj
nnoremap k gk

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Adjust viewports to the same size
map <Leader>= <C-w>=

" Adjust current viewport to 84 characters wide
map <Leader>\ <C-w>84<bar>

" Toggle paste
set pastetoggle=<F2>

" Toggle spell check
nnoremap <silent> <leader>sp :set spell! spelllang=en_us<CR>

" Toggle line numbers
noremap <silent> <Leader>ln :set number!<CR>

" Toggle line wrapping
noremap <silent> <Leader>lw :set wrap!<CR>

" Switch to next buffer
noremap <silent> <Right> :bn<CR>

" Switch to previous buffer
noremap <silent> <Left> :bp<CR>

" List buffers
noremap <silent> <Up> :ls<CR>

" Browse recent files
noremap <silent> <leader>rf :browse old<CR>

" Toggle search highlighting (duplicates vim-sensible funtionality)
"nnoremap <silent> <leader>hl :noh<CR>

" Easy Align
" Start interactive EasyAlign in visual mode (e.g. vipga)
"xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
"nmap ga <Plug>(EasyAlign)

" Fugitive
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>

" YCM 
map <F9> :YcmCompleter FixIt<CR>

" Open files in home with dmenu
nnoremap <silent> <leader>ff :call DmenuOpen("e", "$HOME", 0)<CR>

" Open files in current working directory with dmenu
nnoremap <silent> <leader>fc :call DmenuOpen("e", "$cwd", 1)<CR>

"---Plugin Settings---"
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_confirm_extra_conf = 0

"---Functions---"
" Strip the newline from the end of a string
function! Chomp(str)
    return substitute(a:str, '\n$', '', '')
endfunction

" Find a file in dir and pass it to cmd
function! DmenuOpen(cmd, dir, modTime)
    " Get colors for dmenu from colorscheme
    let nb = "'" . synIDattr(hlID('Pmenu'), 'bg', 'GUI') . "'"
    let nf = "'" . synIDattr(hlID('Pmenu'), 'fg', 'GUI') . "'"
    let sb = "'" . synIDattr(hlID('PmenuSel'), 'bg', 'GUI') . "'"
    let sf = "'" . synIDattr(hlID('PmenuSel'), 'fg', 'GUI') . "'"
    let dmc = "dmenu -i -l 16 -nb " . l:nb .
                \ " -nf " . l:nf . " -sb " . l:sb . " -sf " . l:sf 
    
    " See find docs for blacklist syntax
    let blacklist = "! -path '*cache/*' ! -path '*.mozilla/*'
                \ ! -path '*.git/*' ! -path '*.icons/*' ! -path '*.fonts/*'
                \ ! -path '*.local/*' ! -name '*.swp'"
    if a:modTime
        " Sort by last modified time (slowish)
        let findc = 'find -L ' . a:dir . ' -type f ' . l:blacklist .
                    \ ' -printf "%T@:%p\n" | sort -nr | cut -d: -f2-' 
    else
        let findc = "find -L " . a:dir . " -type f " . l:blacklist
        "let findc = "find -L " . a:dir . " -type f " . l:blacklist . " | sort"
    endif

    silent let fname = Chomp(system(l:findc . " | " . l:dmc))
    if empty(fname)
        return
    endif
    execute a:cmd . " " . fname
endfunction

