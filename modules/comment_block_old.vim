
function! StartCommentBlock() range

	let commstr = split(&commentstring, '%s')

	if empty(commstr)
		echo 'The buffer has not tamplate for a comment.
				\Check "commentstring" option'
		return 0
	endif

	let fl = a:firstline
	let ll = a:lastline

	if len(commstr) == 1
		call SetSingleLineCommentBlock(fl, ll, commstr[0])

	elseif len(commstr) == 2
		call SetMultiLineBlock(fl, ll, commstr[0], commstr[1])

	else
		echoe 'Error: unknown template for comments
				\Check "commentstring" option'
	endif

endfunction

function SetSingleLineCommentBlock(fl, ll, op_blk) range

	let lines = getline(a:fl, a:ll)
	let add_comment_block = 0
	for line in lines
		let empty_line = match(line, '\v^\s*$')
		if empty_line >= 0
		       	continue
	       	endif

		" Escape control characters if this happens
		let pat = '\v(\*)|(\+)|(\\)|(\/)|(\.)'
		let op_blk = substitute(a:op_blk, pat, '\\&', 'g')

		let e = '\v^\W*'.op_blk
		let m = match(line, e)
		if m == -1
			let add_comment_block = 1
			break
		endif
	endfor


"	let save_cursor = getcurpos()
	if add_comment_block
		exec a:fl.','a:ll . 's/\v^(.+)/'.op_blk.'\1/'
	else
		exec a:fl.','a:ll . 's/\v('.op_blk.')?//'
	endif
"	call setpos('.', save_cursor)
endfunction


function SetMultiLineBlock(fl, ll, op_blk, cl_blk) range

	let add_comment_block = 1

	if a:fl == a:ll

		let l = a:fl
		let firstblk = -1
		let lastblk = -1

		let stop = 0
		let firstblk = FindMultiLineBlock(a:fl, a:op_blk, a:cl_blk, -1)


		if firstblk == -1
			let add_comment_block = 1
		else
			let add_comment_block = 0
			let lastblk =  FindMultiLineBlock(a:fl, a:cl_blk, a:op_blk, 1)
		endif
	endif

	if add_comment_block
		call AddMultiLineBlock(a:fl, a:ll, a:op_blk, a:cl_blk)
	else
		call RemoveMultiLineBlock(firstblk, lastblk)
	endif
endfunction


function FindMultiLineBlock(l, op_blk, cl_blk, direction)

	" Escape control characters if this happens
	let pat = '\v(\*)|(\+)|(\\)|(\/)|(\.)'
	let op_blk = substitute(a:op_blk, pat, '\\&', 'g')
	let cl_blk = substitute(a:cl_blk, pat, '\\&', 'g')

	let l = a:l
	let expect_line = -1
	
	if a:direction == -1
		let endline = 0
	else
		let endline = line("$")
	endif

	let stop = 0
	while !stop 
		let line = getline(l)
		let mop = match(line, op_blk)
		let mcl = match(line, cl_blk)

		if mcl != -1
			let stop = 1

		elseif mop != -1 
			let expect_line = l
			let stop = 1

		elseif l == endline
			let stop = 1
		endif
		let l += a:direction
	endwhile
	return expect_line

endfunction


function AddMultiLineBlock(fl, ll, op_blk, cl_blk)
	call append(a:fl-1, a:op_blk)
	call append(a:ll+1, a:cl_blk)

endfunction


function RemoveMultiLineBlock(flb, llb)
		let cursor = getcurpos()
		if a:llb != -1
			exec a:llb."delete"
		endif
		exec a:flb."delete"
		call setpos(".", cursor)
endfunction

noremap <C-/> :call StartCommentBlock()<CR>

echom "module: Comment Block "
