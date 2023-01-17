
let s:brackets = {
	\'(':')',
	\'{':'}',
	\'[':']',
	\'<':'>',
	\}

let s:op_brts = keys(s:brackets)
let s:cl_brts = values(s:brackets)

let s:quotes = ['"',"'"]

augroup autopairs
	autocmd! 
	autocmd InsertCharPre * call PairCharactersProcess()
augroup END


let s:insert_event_scope = 0
function PairCharactersProcess()
	let char = v:char

	let l = getline(".") 
	let c = col(".") 

	" If typed open bracket 
	if index(s:op_brts, char) != -1
		call InsertOpenBracketProcess(char, l, c)
		return
		
	" If typed closed bracket 
	elseif index(s:cl_brts, char) != -1
		call InsertClosedBracketProcess(char, l, c)
		return
	
	" If typed qoute 
	elseif index(s:quotes, char) != -1
		call InsertQuotesProcess(char, l,c)
		return
	endif
endfunction


function InsertOpenBracketProcess(char, l,c)

	let idx = index(s:op_brts, a:char)
	let op_brt = s:op_brts[idx]
	let cl_brt = s:cl_brts[idx]

	" If there is some literal except close bracket then do nothing.
	if match(a:l, '\%'.a:c.'c'.cl_brt.'\@!\S') != -1
"	if match(a:l, '\%'.a:c.'c\w') != -1
		return


	" Append the closed bracket.
	else
		call feedkeys(cl_brt."\<Left>")
		let s:insert_event_scope = 1
	endif

endfunction

function InsertClosedBracketProcess(char, l,c)

	let idx = index(s:cl_brts, a:char)

	if s:insert_event_scope
		let s:insert_event_scope = 0	
		return
	endif

	let cl_brt = s:cl_brts[idx]

	" If there is open bracket before removes it.
	if match(a:l, '\%'.a:c.'c'.cl_brt) != -1
		call feedkeys("\<Del>")
	endif

endfunction


function RemovePairCharactersProcess()
	let l = getline(".")
	let c = col(".")
	let char = matchstr(l, '\%'.c.'c.')

	let opbrt_idx = index(s:op_brts, char)
	let clbrt_idx = index(s:cl_brts, char) 
	let quote_idx = index(s:quotes, char)
	
	" If there is closed bracket after remove both"
	if opbrt_idx != -1
		let op_brt = s:op_brts[opbrt_idx]
		let cl_brt = s:cl_brts[opbrt_idx]

		let m = match(l, '\%'.(c+1).'c'.cl_brt)
		if m != -1
			exec "normal! xx"
			return
		endif

	" If there is open bracket before remove both"
	elseif clbrt_idx != -1
		let cl_brt = s:cl_brts[clbrt_idx]
		let op_brt = s:op_brts[clbrt_idx]
		
		let m =  match(l, '\%'.(c-1).'c'.op_brt)

		if m != -1
			exec "normal! hxx"
			return
		endif

	" If there is qoute after or before remove both"
	elseif quote_idx != -1
		let quote = s:quotes[quote_idx]
		let m_aft =  match(l, '\%'.(c+1).'c'.quote)
		let m_bef =  match(l, '\%'.(c-1).'c'.quote)

		if m_aft != -1
			exec "normal! xx"
			return
		elseif m_bef != -1
			exec "normal! hxx"
			return
		endif

	endif
	execute "normal! x"
endfunction

function InsertQuotesProcess(char, l,c)

	let quote = a:char				

	" If there is the same quote remove one
	if match(a:l, '\v%'.a:c.'c'.quote) != -1
		call feedkeys("\<Del>")

	" If there is any symbol nearby do nothing
	elseif match(a:l, '\v(\S%'.a:c.'c)|(%'.a:c.'c\S)') != -1
		return

	else
		call feedkeys(quote."\<Left>")
	endif

endfunction

noremap <silent> x :call RemovePairCharactersProcess()<CR>

"augroup aoutosourcing
"	autocmd! 
"	autocmd BufWritePost bracket_pairs.vim source %
"augroup END

echom "module: Bracket Pairse"



