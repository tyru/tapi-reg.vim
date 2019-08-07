scriptencoding utf-8
if exists('g:loaded_tapi_reg') && g:loaded_tapi_reg
  finish
endif
let g:loaded_tapi_reg = 1
let s:save_cpo = &cpo
set cpo&vim


function! Tapi_reg(bufnr, args) abort
  if empty(a:args)
    return
  endif
  if a:args[0] ==# 'set' && len(a:args) >= 3
    if !s:set_clipboard(a:args[1], a:args[2])
      let [reg, file] = a:args[1:2]
      let value = join(readfile(file), "\n")
      call setreg(reg, value)
    endif
  elseif a:args[0] ==# 'get' && len(a:args) >= 3
    if a:args[1] ==# '--list'
      let lines = split(execute('registers', 'silent'), '\n')
      let filename = a:args[2]
    else
      let lines = getreg(a:args[1], 1, 1)
      let filename = a:args[2]
    endif
    call writefile(lines, filename)
  endif
endfunction

function! s:set_clipboard(reg, file) abort
  if (a:reg ==# '+' || a:reg ==# '*') && !has('clipboard')
    let cmd = s:is_wsl() ? 'clip.exe' : has('macunix') ? 'pbcopy' : ''
    if !empty(cmd)
      let value = join(readfile(a:file), "\n")
      call system('clip.exe', value)
      return !v:shell_error
    endif
  endif
  return 0
endfunction

function! s:is_wsl() abort
  if exists('s:is_wsl')
    return s:is_wsl
  endif
  let s:is_wsl = (filereadable('/proc/sys/kernel/osrelease') &&
  \               join(readfile('/proc/sys/kernel/osrelease'), "\n") =~? 'Microsoft')
  return s:is_wsl
endfunction


let &cpo = s:save_cpo
