vim9script

&l:wildignore = '__pycache__,*.pyc,*.pyo,*.pyd'
&l:path = '.,./**,,'

&l:include = '\v^\s*(import|from)\s*\zs.{-}\ze(,|<as>|\*|$)'

def IncludeExpretion(input: string): string

    # remove Whitespaces
    var fname = substitute(input, '\s\+', '', 'g')
    # remove extreme point
    fname = substitute(fname, '\v^\s*\zs\.', '', '')
    # replace dots beetwen words to slashes
    fname = substitute(fname, '\v>\.<', '/', 'g')
    # replace upward points to upward pattern (. to ../)
    fname = substitute(fname, '\.', '../', 'g')

    var parts = split(fname, 'import')
    var var1 = join(parts, '/') .. ".py"
    var var2 = parts[0] .. ".py"

    var RemoveUpDots = (s): string => substitute(s, '\.\.\/', '', 'g')

    if !empty(globpath(&path, RemoveUpDots(var1)))
#       echo "- globpath1: " .. globpath(&path, RemoveUpDots(var1))
        return var1

    elseif !empty(globpath(&path, RemoveUpDots(var2)))
#       echo "- globpath2: " .. globpath(&path, RemoveUpDots(var2))
        return var2

    else
#       echo "+ VAR: " .. fname
        return ""
    endif
enddef

set includeexpr=<SID>IncludeExpretion(v:fname)

# echom "plugin: PythonInclude"
