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
    call call('setreg', a:args[1:])
  elseif a:args[0] ==# 'get' && len(a:args) >= 2
    " Send string with EOF
    call term_sendkeys(a:bufnr, getreg(a:args[1], 1) . "\<C-d>")
  endif
endfunction


let &cpo = s:save_cpo
