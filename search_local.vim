function LocaWordSetRegister()
	let l = getline(".")
	let c = col(".")
	let pat = '\w\+\%'.c.'c\w\+'
	return matchstr(l, pat, '')
endfunc

function SearchLocalWord()
	let word = LocaWordSetRegister()	
	if !empty(word) 
		let @/ = word
		return "\e"
	else
		return ""
	endif
endfunc

function SubstituteLocalWord()

	let mode = mode()

	if "v" =~ mode
		let sl = getpos("v")[1]
		let el = getpos(".")[1]
		if sl isnot el
			echom "Given more then one line."
			unlet sl
			unlet el
			let phrase = ""
		else	
			let s_col = getpos("v")[2]	
			let e_col = getpos(".")[2]	
			let phrase = getline(".")[:e_col - 1]
			let phrase = phrase[s_col - 1:]
		endif

	elseif "n" =~ mode
		let phrase = LocaWordSetRegister()	
	else
		let phrase = ""
	endif

	if !empty(phrase)
		let @" = phrase

		let left = repeat("\<Left>", 27)

		" --- h :range {address} ---
		let set_mark = "m0"
		let substitute = ".,$s/".phrase."//gce | 1,'0-1&&"
		let jump_tomark = "normal `0"
		
		let cmd = "\e".set_mark.":".substitute . " | " . jump_tomark . left 
		return cmd
	else
		echom "Nothing to do."
		return "\e"
	endif
endfunc

echo "module: Local Searching"
