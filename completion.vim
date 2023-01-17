
augroup CompletionFinish
	autocmd! 
	autocmd CompleteDone * call ProcessFinishCompleteion()
augroup END


function ProcessFinishCompleteion()

	let word = get(v:completed_item, 'word')

	if empty(word)
		return
	endif

	let isslash = match(word, '\/$', '')
	if isslash != -1
		call feedkeys("\<C-X>\<C-F>")
	else 
		call feedkeys("\<C-N>")
	endif

endfunction


inoremap <Tab> <C-R>=CleverTab()<CR>
inoremap <expr> <C-J> Completed()

function CleverTab()
	let items = get(complete_info(), 'items', '[]')
	if !empty(items)
		return "\<C-N>"
	endif

   let textstate = strpart( getline('.'), 0, col('.')-1 )
   if textstate =~ '^\s*$'
	  return "\<Tab>"

   elseif match(textstate, '\/$', '') != -1
		   return "\<C-X>\<C-F>"
   endif
   return "\<C-N>"
endfunction

function Completed()
	let items = get(complete_info(), 'items', '[]')
	if empty(items)
		return "\<C-J>"
	else
		return "\<C-Y>"
	endif
endfunction

echom "module: Competion"
