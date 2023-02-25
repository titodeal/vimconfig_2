let s:brackets = {
	\'(':')',
	\'{':'}',
	\'[':']',
	\'<':'>',
	\'"':'"',
	\"'":"'", 
	\}

function! MapBracketWrapping()

	for key in keys(s:brackets)
		let op = key
		let cl = s:brackets[key]

		let args = "('".op."', '".cl."')"
		let args = substitute(args, "'''", "\"'\"", 'g')
		execute 'vnoremap <silent> '.op.' :call BracketWrapping'.args.'<CR>'
	endfor
endfunction

function! BracketWrapping(op,cl) range

	if a:firstline != a:lastline
		call execute("normal! gv".a:op)
		return
	endif

	let pat = '\(\%V.\+\%V\)'
	let sub = a:op.'\1'.a:cl
	exe ':substitute/'.pat.'/'.sub.'/e'
	normal! `>l

endfunction

call MapBracketWrapping()

echom "module: Bracket Wrapping"









