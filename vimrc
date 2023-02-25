vim9script

source $VIMRUNTIME/defaults.vim

&t_SI = "\e[5 q"
&t_EI = "\e[2 q"

g:mapleader = ","

colorscheme substrata

# Split Window priority
set splitright
set splitbelow

# Set indent
set expandtab softtabstop=-1 shiftwidth=4
# Set separate window charachters.
set fillchars=vert:.,fold:-,stl:\ ,stlnc:\ ,diff:-
# Show statusline always.
set laststatus=2
# Set row number
set number
# Disable recursive search.
set nowrapscan
# Enable mouse. To use terminal clipboard press and hold Shift key.
set mouse=a
# Rrovides mouse response beyond 230 column.
set ttymouse=sgr

# Avoid comment line while 'O' or <Enter>.
# Exclude 'o' and 'r' flag'.
set formatoptions=cql

augroup aoutosourcing
	autocmd! 
	autocmd BufWritePost vimrc source %
	autocmd BufWritePost *.vim source %
augroup END

