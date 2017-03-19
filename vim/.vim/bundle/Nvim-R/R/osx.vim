" This file contains code used only on OS X

if isdirectory("/Applications/R64.app")
    let g:rplugin_r64app = 1
else
    let g:rplugin_r64app = 0
endif

function StartR_OSX()
    if IsSendCmdToRFake()
        return
    endif
    if g:rplugin_r64app
        let rcmd = "/Applications/R64.app"
    else
        let rcmd = "/Applications/R.app"
    endif

    let args_str = join(g:rplugin_r_args)
    if args_str != " "
        " https://github.com/jcfaria/Vim-R-plugin/issues/63
        " https://stat.ethz.ch/pipermail/r-sig-mac/2013-February/009978.html
        call RWarningMsg('R.app does not support command line arguments. To pass "' . args_str . '" to R, you must put "let R_applescript = 0" in your vimrc to run R in a terminal emulator.')
    endif
    let rlog = system("open " . rcmd)
    if v:shell_error
        call RWarningMsg(rlog)
    endif
    let g:SendCmdToR = function('SendCmdToR_OSX')
    if WaitNvimcomStart()
        call foreground()
        sleep 200m
        if g:R_after_start != ''
            call system(g:R_after_start)
        endif
    endif
endfunction

function SendCmdToR_OSX(...)
    if g:R_ca_ck
        let cmd = "\001" . "\013" . a:1
    else
        let cmd = a:1
    endif

    if g:rplugin_r64app
        let rcmd = "R64"
    else
        let rcmd = "R"
    endif

    " for some reason it doesn't like "\025"
    let cmd = substitute(cmd, "\\", '\\\', 'g')
    let cmd = substitute(cmd, '"', '\\"', "g")
    let cmd = substitute(cmd, "'", "'\\\\''", "g")
    call system("osascript -e 'tell application \"".rcmd."\" to cmd \"" . cmd . "\"'")
    return 1
endfunction

