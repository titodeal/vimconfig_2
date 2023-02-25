vim9script 
# Vim global plugin for Tab completion
# Last Change: 2023 Feb 13
# Maintainer: anShell

if exists("g:loaded_clevertab")
    finish
endif
g:loaded_clevertab = 1


def CleverTab()
    var xcmd = exists('b:xcmd') ? b:xcmd : "\<C-N>"
    var text = strpart(getline('.'), 0, col('.') - 1)
    var lstchar = text[-1 : ]

    if text =~ '^\s*$'
        feedkeys("\<Tab>", 'n')
    else
        cursor(line('.'), col('.') - 1)
        var cfile = expand('<cfile>')
        cursor(line('.'), col('.') + 1)

        if match(cfile, '\v^\.?\.?\/') != -1
            if !pumvisible() || lstchar == '/'
                xcmd = "\<C-X>\<C-F>"
            endif
        endif
        feedkeys(xcmd, 'n')
    endif
enddef

if !hasmapto('<Plug>CleverTab;', 'i')
    imap <unique> <Tab> <Plug>CleverTab;
endif

inoremap <Plug>CleverTab; <Cmd>call <SID>CleverTab()<CR>

echom "plugin: CleverTab"
