vim9script


#unlet g:loaded_commentblock
if exists("g:loaded_commentblock")
    finish
endif
g:loaded_commentblock = 1


def StartCommentBlock(type = ''): string

	if empty(type)
            &operatorfunc = function('StartCommentBlock')
            return "g@"
        endif

	var commstr = split(&commentstring, '%s')
	if empty(commstr)
            echo 'The buffer has not tamplate for a comment.
                            \Check "commentstring" option'
            return ''
	endif
        
        var fl = line("'[")
        var ll = line("']")
	echom "FirstLine: " .. fl
	echom "SeconLine: " .. ll

	if len(commstr) == 1
		SetSingleLineCommentBlock(fl, ll, commstr[0])
                return ''

	elseif len(commstr) == 2
		SetMultiLineBlock(fl, ll, commstr[0], commstr[1])
        	return ''

	else
		echoe 'Error: unknown template for comments
				\Check "commentstring" option'
                return ''
	endif

enddef

def SetSingleLineCommentBlock(fl: number, ll: number, _op_blk: string)

        var op_blk = _op_blk
	var lines = getline(fl, ll)
	var add_comment_block = 0

	for line in lines
		var empty_line = match(line, '\v^\s*$')
		if empty_line >= 0
		       	continue
	       	endif

		# Escape control characters if it happens
		var pat = '\v(\*)|(\+)|(\\)|(\/)|(\.)'
		op_blk = substitute(op_blk, pat, '\\&', 'g')

		var e = '\v^\W*' .. op_blk
		var m = match(line, e)
		if m == -1
			add_comment_block = 1
			break
		endif
	endfor


#	var save_cursor = getcurpos()
        var range = ':' .. fl .. ',' .. ll
	if add_comment_block
		execute range .. 's/\v^/' .. op_blk 
        else
		execute range .. 's/\v^\s*\zs(' .. op_blk .. ')?\ze//'
	endif
#	call setpos('.', save_cursor)
enddef


def SetMultiLineBlock(fl: number, ll: number, _op_blk: string, _cl_blk: string)

        var op_blk = _op_blk
        var cl_blk = _cl_blk
	var add_comment_block = 1
        #var firstblk: number
        #var lastblk: number
        var firstblk = -1
        var lastblk = -1

	if fl == ll

		var l = fl

		var stop = 0
		firstblk = FindMultiLineBlock(fl, op_blk, cl_blk, -1)


		if firstblk == -1
			add_comment_block = 1
		else
			add_comment_block = 0
			lastblk =  FindMultiLineBlock(fl, cl_blk, op_blk, 1)
		endif
	endif

	if add_comment_block
		AddMultiLineBlock(fl, ll, op_blk, cl_blk)
	else
		RemoveMultiLineBlock(firstblk, lastblk)
	endif
enddef


def FindMultiLineBlock(_l: number, _op_blk: string, _cl_blk: string, direction: number): number

	# Escape control characters if this happens
	var pat = '\v(\*)|(\+)|(\\)|(\/)|(\.)'
	var op_blk = substitute(_op_blk, pat, '\\&', 'g')
	var cl_blk = substitute(_cl_blk, pat, '\\&', 'g')

        var l = _l
	var expect_line = -1
        var endline: number
	
	if direction == -1
		endline = 0
	else
		endline = line("$")
	endif

	var stop = 0
	while !stop 
		var line = getline(l)
		var mop = match(line, op_blk)
		var mcl = match(line, cl_blk)

		if mcl != -1
			stop = 1

		elseif mop != -1 
			expect_line = l
			stop = 1

		elseif l == endline
			stop = 1
		endif
		l += direction
	endwhile
	return expect_line

enddef


def AddMultiLineBlock(fl: number, ll: number, op_blk: string, cl_blk: string)
	append(fl - 1, op_blk)
	append(ll + 1, cl_blk)

enddef


def RemoveMultiLineBlock(flb: number, llb: number)
		var cursor = getcurpos()
		if llb != -1
			exec ':' .. llb .. "delete"
		endif
		exec ':' .. flb .. "delete"
		call setpos(".", cursor)
enddef


#if !hasmapto('<Plug>CommentBlock;', 'nvs')
#    nnoremap <unique> <C-/> <Plug>CommentBlock;
#    nnoremap <unique> <C-/><C-/> <Plug>CommentBlock;
#    vnoremap <unique> <C-/> <Plug>CommentBlock;
#endif
#nnoremap <expr> <Plug>CommentBlock <SID>StartCommentBlock()
#nnoremap <expr> <Plug>CommentBlock <SID>StartCommentBlock() .. '_'
#vnoremap <expr> <Plug>CommentBlock <SID>StartCommentBlock()

nnoremap <expr> <C-/> <SID>StartCommentBlock()
nnoremap <expr> <C-/><C-/> <SID>StartCommentBlock() .. '_'
vnoremap <expr> <C-/> <SID>StartCommentBlock()

echom "module: Comment Block "
