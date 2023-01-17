" Split Window priority
set splitright
set splitbelow

" Split and move keymaps
execute "set <A-w>=\x1bw"
execute "set <A-W>=\x1bW"
nnoremap <A-W> :botright split<CR>
nnoremap <A-w> :split<CR>
nnoremap <S-W> :vsplit<CR>
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <leader>q :q<CR>
nnoremap !<leader>q :q!<CR>

" Split and move terminal
nnoremap <leader><S-W> :vertical term <CR>
tnoremap <C-J> <C-W>j 
tnoremap <C-K> <C-W>k
tnoremap <C-H> <C-W>h
tnoremap <C-L> <C-W>l
tnoremap <leader>q <C-W>N:q!<CR>

"Command line keys
noremap! <C-U> <C-W>
noremap! <C-H> <C-Left>
noremap! <C-L> <C-Right>

"Saving
nnoremap <C-s> :write<CR>

nnoremap <F3> :set hlsearch!<CR>

" Searching by local word
nnoremap <expr> <leader>f SearchLocalWord()

" Substitute local word in normal mode and selection in visual mode"
noremap <expr> <F2> SubstituteLocalWord()

" Comment Block. The function is located in comment_block.vim module.
noremap <C-_> :call StartCommentBlock()<CR>

" Completation"
"

"au CmdwinEnter : complete"
"

echom "module: Mapping"
