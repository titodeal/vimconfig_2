let mapleader = ","

colorscheme substrata

so $VIMRUNTIME/defaults.vim
so ~/.vim/bracket_pairs.vim
so ~/.vim/bracket_wrapping.vim
so ~/.vim/comment_block.vim
so ~/.vim/search_local.vim
so ~/.vim/shelljob.vim
so ~/.vim/statusline.vim
"so ~/.vim/completion.vim
so ~/.vim/mapping.vim


"filetype plugin on
"let g:pydiction_location = '/home/ubu/.vim/bundle/pydiction/complete-dict'


" Set separate window charachters.
set fillchars=vert:.,fold:-,stl:\ ,stlnc:\ ,diff:-
" Show statusline always.
set laststatus=2
" Set row number
set number
" Disable recursive search.
set nowrapscan
" Enable mouse. To use terminal clipboard press and hold Shift key.
set mouse=a
" Rrovides mouse response beyond 230 column.
set ttymouse=sgr

" Avoid comment line while 'O' or <Enter>.
" Exclude 'o' and 'r' flag'.
set formatoptions=cql

set tabstop=4
set shiftwidth=4

"Command line mapping.

augroup aoutosourcing
	autocmd! 
	autocmd BufWritePost vimrc source %
	autocmd BufWritePost *.vim source %
augroup END















