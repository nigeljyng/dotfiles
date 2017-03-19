" This file contains code used only when R run in Neovim buffer

function ExeOnRTerm(cmd)
    let curwin = winnr()
    exe 'sb ' . g:rplugin_R_bufname
    exe a:cmd
    call cursor("$", 1)
    exe curwin . 'wincmd w'
endfunction

function SendCmdToR_Neovim(...)
    if g:rplugin_jobs["R"]
        if g:R_ca_ck
            let cmd = "\001" . "\013" . a:1
        else
            let cmd = a:1
        endif

        if !exists("g:R_hl_term") || !exists("g:R_setwidth")
            call SendToNvimcom("\x08" . $NVIMR_ID . 'paste(search(), collapse=" ")')
            let g:rplugin_lastev = ReadEvalReply()
            if !exists("g:R_hl_term")
                if g:rplugin_lastev =~ "colorout"
                    let g:R_hl_term = 0
                else
                    let g:R_hl_term = 1
                endif
            endif
            if !exists("g:R_setwidth")
                if g:rplugin_lastev =~ "setwidth"
                    let g:R_setwidth = 0
                else
                    let g:R_setwidth = 1
                endif
            endif
        endif

        if !exists("g:rplugin_hl_term")
            let g:rplugin_hl_term = g:R_hl_term
            if g:rplugin_hl_term
                call ExeOnRTerm('set filetype=rout')
            endif
        endif

        " Update the width, if necessary
        if g:R_setwidth && len(filter(tabpagebuflist(), "v:val =~ bufnr(g:rplugin_R_bufname)")) >= 1
            call ExeOnRTerm("let s:rwnwdth = winwidth(0)")
            if s:rwnwdth != g:rplugin_R_width && s:rwnwdth != -1 && s:rwnwdth > 10 && s:rwnwdth < 999
                let g:rplugin_R_width = s:rwnwdth
                call SendToNvimcom("\x08" . $NVIMR_ID . "options(width=" . g:rplugin_R_width. ")")
                sleep 10m
            endif
        endif

        if a:0 == 2 && a:2 == 0
            call jobsend(g:rplugin_jobs["R"], cmd)
        else
            call jobsend(g:rplugin_jobs["R"], cmd . "\n")
        endif
        return 1
    else
        call RWarningMsg("Is R running?")
        return 0
    endif
endfunction

function OnTermClose()
    if exists("g:rplugin_R_bufname")
        if g:rplugin_R_bufname == bufname("%")
            if g:R_close_term
                call feedkeys('<cr>')
            endif
        endif
        unlet g:rplugin_R_bufname
    endif

    " Set nvimcom port to 0 in nclientserver
    if g:rplugin_jobs["ClientServer"]
        call jobsend(g:rplugin_jobs["ClientServer"], "\001R0\n")
    endif
endfunction

function SendCmdToR_NotYet(...)
    call RWarningMsg("Not ready yet")
endfunction

function StartR_Neovim()
    if string(g:SendCmdToR) != "function('SendCmdToR_fake')"
        return
    endif
    let g:R_tmux_split = 0

    let g:SendCmdToR = function('SendCmdToR_NotYet')

    let edbuf = bufname("%")
    let objbrttl = b:objbrtitle
    let curbufnm = bufname("%")
    set switchbuf=useopen
    if g:R_vsplit
        if g:R_rconsole_width > 16 && g:R_rconsole_width < (winwidth(0) - 17)
            silent exe "belowright " . g:R_rconsole_width . "vnew"
        else
            silent belowright vnew
        endif
    else
        if g:R_rconsole_height > 0 && g:R_rconsole_height < (winheight(0) - 1)
            silent exe "belowright " . g:R_rconsole_height . "new"
        else
            silent belowright new
        endif
    endif
    if has("win32")
        call SetRHome()
    endif
    let g:rplugin_jobs["R"] = termopen(g:rplugin_R . " " . join(g:rplugin_r_args), {'on_exit': function('ROnJobExit')})
    if has("win32")
        redraw
        call jobsend(g:rplugin_jobs["R"], g:rplugin_R . " " . join(g:rplugin_r_args) . " && exit\r\n")
        call UnsetRHome()
    endif
    let g:rplugin_R_bufname = bufname("%")
    let g:rplugin_R_width = 0
    let b:objbrtitle = objbrttl
    let b:rscript_buffer = curbufnm
    if exists("g:R_hl_term") && g:R_hl_term
        set filetype=rout
        let g:rplugin_hl_term = g:R_hl_term
    endif
    if g:R_esc_term
        tnoremap <buffer> <Esc> <C-\><C-n>
    endif
    autocmd TermClose <buffer> call OnTermClose()
    exe "sbuffer " . edbuf
    stopinsert
    if WaitNvimcomStart()
        let g:SendCmdToR = function('SendCmdToR_Neovim')
    endif
endfunction

" To be called by edit() in R running in Neovim buffer.
function ShowRObject(fname)
    let fcont = readfile(a:fname)
    exe "tabnew " . substitute($NVIMR_TMPDIR . "/edit_" . $NVIMR_ID, ' ', '\\ ', 'g')
    call setline(".", fcont)
    set filetype=r
    stopinsert
    autocmd BufUnload <buffer> call delete($NVIMR_TMPDIR . "/edit_" . $NVIMR_ID . "_wait") | startinsert
endfunction

if has("win32")
    " The R package colorout only works on Unix systems
    call RSetDefaultValue("g:R_hl_term", 1)
endif
