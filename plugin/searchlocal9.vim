vim9script


# unlet g:loaded_searchlocal
if exists("g:loaded_searchlocal")
    finish
endif
g:loaded_searchlocal = 1


def SearchLocalWord(cword = '<cword>'): string
	var word = expand(cword)
	var result = ''
	if !empty(word) 
		@/ = word
		set hlsearch
		result = "\<Nul>"
	endif
	return result
enddef


def SubstituteLocalWord(cword = '<cword>'): string

	var mode = mode()
	var phrase = ''

	if 'v' =~ mode
		var sl = getpos("v")[1]
		var el = getpos(".")[1]
		if sl != el
			echom "Given more then one line."
		else	
			var s_col = getpos("v")[2]	
			var e_col = getpos(".")[2]	
			phrase = getline(".")[ : e_col - 1]
			phrase = phrase[s_col - 1 : ]
		endif

	elseif 'n' =~ mode
		phrase = expand(cword)
	endif

	if !empty(phrase)
		@" = phrase

		var left = repeat("\<Left>", 27)

#		 --- h :range {address} ---
		var set_mark = 'm0'
		var substitute = ".,$s/" .. phrase .. "//gce | 1,'0-1&&"
		var jump_tomark = "normal `0"
		
		var cmd = "\e" .. set_mark .. ":" .. substitute .. " | " .. jump_tomark .. left 
		return cmd
	else
		echom "Nothing to do."
		return "\<Nul>"
	endif
enddef

if !hasmapto('<Plug>SearchLocalWord;', 'n')
     nnoremap <unique> <leader>f <Plug>SearchLocalWord;
endif

if !hasmapto('<Plug>SearchLocalBigWord;', 'n')
     nnoremap <unique> <leader>F <Plug>SearchLocalBigWord;
endif

if !hasmapto('<Plug>SubstituteLocalWord;', 'vn')
     noremap <unique> <F2> <Plug>SubstituteLocalWord;
endif

if !hasmapto('<Plug>SubstituteLocalBigWord;', 'vn')
     noremap <unique> <leader><F2> <Plug>SubstituteLocalBigWord;
endif

noremap <expr> <Plug>SubstituteLocalWord; <SID>SubstituteLocalWord()
noremap <expr> <Plug>SubstituteLocalBigWord; <SID>SubstituteLocalWord('<cWORD>')
nnoremap <expr> <Plug>SearchLocalWord; <SID>SearchLocalWord()
nnoremap <expr> <Plug>SearchLocalBigWord; <SID>SearchLocalWord('<cWORD>')

echo "module: Local Searching"

