
" Color for midified item
:hi FileModified ctermfg=11 ctermbg=240
:hi FileNoModified ctermfg=blue ctermbg=240
:hi FileModifiedNC ctermfg=11 ctermbg=235
:hi FileNoModifiedC ctermfg=blue ctermbg=235 

" Color for type of file
:hi FileType ctermfg=17 ctermbg=240
:hi FileTypeNC ctermfg=31 ctermbg=235

" Color for file truncator line
:hi Truncate ctermfg=17 ctermbg=240
:hi TruncateNC ctermfg=31 ctermbg=235

" Color for [Preview] marker
:hi PreviewMarker ctermfg=17 ctermbg=240
:hi PreviewMarkerNC ctermfg=31 ctermbg=235

" Colors for different modes
" -normal
:hi NormalMode ctermfg=17 ctermbg=240
" -insert
:hi InsertMode ctermfg=51 ctermbg=240
" -visual
:hi VisualMode ctermfg=33 ctermbg=240
" -replace
:hi ReplaceMode ctermfg=226 ctermbg=240
" -select
:hi SelectlMode ctermfg=46 ctermbg=240



" Main Statusline function
function StatusLine()
	let s:curwinid = win_getid()
                                                        
	let l:bufnr = '#'.GetBufferNum()
	let l:modified = IsModified()
	let l:file = GetFile()
	let l:txtitems = GetWinItems()
	let l:modifiable = IsModifiable()
	let l:buftype = GetBufferType()
	let l:mode = GetCurrentMode()

	let lft = l:modifiable.l:modified.l:mode.l:file
	let cntr = l:txtitems
	let rgt = l:buftype.l:bufnr
	


	let line = lft.cntr.rgt
	let line_cnt = len(GetPrintableChars(line))

	let winwidth = ExecInStatusWindow("echo winwidth(winnr())")
	let space = repeat(' ', (winwidth - line_cnt) / 2)

	let l:l = printf('%s%s%s%s%s', lft, space, cntr, space, rgt) 
	
	return l:l


endfunction


" Executes command in current status window
function ExecInStatusWindow(cmd)
	let output = win_execute(g:statusline_winid, a:cmd)
	let output = substitute(output, '\n', '', '')
	return output
endfunction


" Discard characters that mean color groups
function GetPrintableChars(l)
	let pat = '\v\%#\w{-}#(.{-})\%\*'
	let printable = substitute(a:l, pat, '\1', 'g')
	let printable = substitute(printable, '\v^\s*(.*)\s*$', '\1', 'g')
	return printable
endfunction


" Retruns item for none modifiable buffer
function IsModifiable()
	let ismodi = ExecInStatusWindow("echo &modifiable")
	return ismodi ? "" : "📌"
endfunction


" Retruns buffer type items
function GetBufferType()
	let buftype = ExecInStatusWindow("echo &buftype")
	let prevwin = ExecInStatusWindow("echo &previewwindow")
	let buftype = substitute(buftype, '\v^(\w)', '\u\1\U', '')
	let buftype = empty(buftype) ? '' : '['.buftype.']'

	if prevwin
		if g:statusline_winid == s:curwinid
			let clr = '%#PreviewMarker#'
		else
			let clr = '%#PreviewMarkerNC#'
		endif
		let buftype = clr.'[Preview]%*'.buftype
	endif

	return buftype

endfunction


" Returns buffer number item
function GetBufferNum()
	let bufnr = ExecInStatusWindow("echo bufnr()")
	return bufnr
endfunction


" Returns mode item
function GetCurrentMode()
	if g:statusline_winid == s:curwinid
		let l:mode = substitute(mode(), '\n' , '', '')

		if "n" == l:mode
			let clr = '%#NormalMode#'
			return '['.clr.'N%*]'

		elseif 'i' == l:mode
			let clr = '%#InsertMode#'
			return '['.clr.'I%*]'

		elseif 'Vv'."\x16" =~ l:mode
			let clr = '%#VisualMode#'
			return '['.clr.'V%*]'

		elseif 'R' == l:mode
			let clr = '%#ReplaceMode#'
		   	return '['.clr.'R%*]'

		elseif 'Ss'."\x13" =~ l:mode
			let clr = '%#SelectlMode#'
			return '['.clr.'S%*]'

		endif
	endif
	return ''
endfunction

" Returns 'modified' item
function IsModified()

	let modified_opt = ExecInStatusWindow("echo &modified")

	let modified_opt = substitute(modified_opt, "\n", "", "")

	" Sets color group for active or not actie window
	if g:statusline_winid == s:curwinid
		let clr_mdf = '%#FileModified#'
		let clr_nomdf = ''
	else
		let clr_mdf = '%#FileModifiedNC#'
		let clr_nomdf = ''
	endif

	if modified_opt
		let mdf = '['.clr_mdf.'+%*]'
	else
		let mdf = ''
	endif

	return mdf

endfunction

" Returns buffer file
function GetFile()

	let winwidth = ExecInStatusWindow("echo winwidth(winnr())")
	let max_lwidth = winwidth/3

	"Sets color group for active or not actie window
	if g:statusline_winid == s:curwinid
		let type_clr = '%#FileType#'
		let truncate_clr = '%#Truncate#'
	else
		let type_clr = '%#FileTypeNC#'
		let truncate_clr = '%#TruncateNC#'
	endif

	let filetype = ExecInStatusWindow("echo &filetype")
	let file = ExecInStatusWindow("echo expand('%:.')")
	let fileroot = fnamemodify(file, ':r')
	let ext = fnamemodify(file, ':e')

	if empty(file)
		return type_clr.'[No Name]%*'
	endif

	if filetype == "help"
		let ext = ''
		let fileroot = fnamemodify(fileroot, ':t')
	endif

	let truncate = ''
	let len = len(fileroot)
	if len > max_lwidth
		let fileroot = fileroot[-max_lwidth:]
		let truncate = truncate_clr.'<%*'
	endif

	if !(empty(filetype) || empty(ext))
		let type =  ".".ext

	elseif !empty(filetype)
		let type = '[.'.filetype.']'
	else
		let type = '[.X]'
	endif

	let type = type_clr.type.'%*'
	let output = truncate.fileroot.type

	return  output

endfunction

" Returns lines and columns
function GetWinItems()
	let column = ExecInStatusWindow("echo col('.')")
	let virtcolumn = ExecInStatusWindow("echo virtcol('.')")
	let curline = ExecInStatusWindow("echo line('.')")
	let numlines = ExecInStatusWindow("echo line('$')")

	let prc = ''
	if numlines > 1000
		let prc = 1.0 * curline / numlines * 100
		let prc = printf('%0.1f', prc).'%%'
	endif

"	let virtcolumn = virtcolumn == column ? '' : ' - '.virtcolumn
"		\column.virtcolumn.'   '.
	let output = prc.'   '.
		\column.'   '.
		\curline.'/'.numlines
	
			return output

endfunction

set statusline=%!StatusLine()

echom "module: Status Line"
