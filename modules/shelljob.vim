augroup tabvariables
	autocmd! 
	autocmd Tabnew * call SetTabAttibutes()
augroup END

augroup autoengine
	autocmd! 
	autocmd FileType python let b:engine = "python3"
	autocmd FileType sh let b:engine = "bash"
augroup END

let g:shell = "/bin/bash"
let t:tabpnr = tabpagenr()
function SetTabAttibutes()
	let t:bfnr = ""
	let t:tabpnr = tabpagenr()
endfunction

function StartShellJob()
	let job = job_start(g:shell, {
				\"out_cb": "OutHandlerResult",
				\"err_cb": "OutHandlerResult",
				\"out_modifiable": 0,
			\})
	return job
endfunction


let s:resp=0
function OutHandlerResult(channel, msg)
	let s:resp += 1
	call appendbufline(t:bfnr, "$", a:msg)
	call win_execute(bufwinid(t:bfnr), "$")
	call win_execute(bufwinid(t:bfnr), "redraw")
"	if (s:resp % 10) == 0
"		call win_execute(bufwinid(t:bfnr), "redraw")
"	endif
endfunction


function SendShellCommand(cmd)

	if !CheckShellJobState()
		echoe "Error: The shell ".g:shell." can't start"
		return 0
	endif

	if !CheckBufferWindow()
		echoe "Error: Cant prepare buffer result window"	
		return 0
	endif

	call ch_sendraw(g:shell_job, a:cmd."\n")

	return 1

endfunction

function CheckShellJobState()
	if !exists("g:shell_job") || empty(g:shell_job)
		let job = StartShellJob()
	else
		let job_status = job_status(g:shell_job)
		if job_status != "run" 
			call job_stop(g:shell_job, "kill")
			let job = StartShellJob()
		else
			let job = g:shell_job
		endif
	endif

	if job_status(job) == "run"
		let g:shell_job = job
		return 1
	else
		let g:shell_job = ""
		return 0
	endif

endfunction

function GetBuerWindow()
	echom " -- Creating New Result Buffer"
	let bufname = "-result- <".b:engine.">_tab:".t:tabpnr
	execute "badd ".bufname
"	execute "ped ".bufname
	
	let bfnr = bufnr(bufname)
	let win = bufwinid(bfnr)

	if win == -1
		exec 'split #'.bfnr
		let win = bufwinid(bfnr)
	endif
	
	" -- Set Buffer Options
"	call win_execute(win, "set nomodifiable")
"	call win_execute(win, "set buftype=terminal")
	call win_execute(win, "set bufhidden=hide")
	call win_execute(win, "set buftype=nofile")
	let t:bfnr = bfnr

	return bfnr
endfunction

function CheckBufferWindow()

	" -- Getting buffer
	if !exists("t:bfnr") || !bufloaded(t:bfnr)
		let bfnr =  GetBuerWindow()
	else
		let bfnr = t:bfnr
	endif

	let win = bufwinid(bfnr)
	if win == -1
		exec "split #".bfnr
		let win = bufwinid(bfnr)
	endif
	" -- Clear Buffer
	call win_execute(win, "1,$delete")

	return 1

endfunction

function TimerWrapperUNIX(cmd)
	let start = 's=\$(date +%s.%5N)'
	let end = 'e=\$(date +%s.%5N)'
	let spend = 'spend=\$(echo \$e - \$s | bc)'
	let result = 'echo FINISH: \[\$spend\]'

	let command = 'eval "'.start.";".a:cmd.";".end.";".spend.";".result.'"'
	return command
endfunction
	


function ExecuteFile()

	if !exists("b:engine") || empty(b:engine)
		echom "Has no Interpreter for this file type"
		return 0
	endif

	let currfile = expand('%:p')

	let execfile_cmd = b:engine ." ". currfile

	silent write
	let s:resp = 0

	let timewrapedcmd = TimerWrapperUNIX(execfile_cmd)
	message clear

	let buf = bufnr()
	let win = bufwinid(buf)
	call SendShellCommand(timewrapedcmd)


endfunction

nmap <leader><C-B> :call ExecuteFile()<CR>

"augroup aoutosourcing
"	autocmd! 
"	autocmd BufWritePost shelljob.vim  source %
"augroup END

echom "module: Shell Job!"

