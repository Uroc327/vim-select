" File:         autoload/select.vim
" Description:  Checkbox selection for vim
" Maintainer:   Constantin Runge <uroc327@cssbook.de>
" Version:      1.0

function! select#SelectToggle()
  call s:SetBufferOptDefault('select_active', 0)
  call s:SetActive(!b:select_active)
endfunction

function! select#SelectEnable()
  call s:SetActive(1)
endfunction

function! select#SelectDisable()
  call s:SetActive(0)
endfunction

function! select#ToggleCheck()
endfunction

function! select#Invert()
endfunction

function! s:SetBufferOptDefault(opt, val)
  if !exists('b:' . a:opt)
    let b:{a:opt} = a:val
  endif
endfunction

function! s:SetActive(active)
  let b:select_active = a:active
  call s:UpdateMappings()
endfunction

function! s:UpdateMappings()
  if exists('b:select_active') && b:select_active
    execute "nnoremap <silent> <buffer> " . g:select_toggle_check_map . " :call select#ToggleCheck()<CR>"
    execute "nnoremap <silent> <buffer> " . g:select_invert_map . " :call select#Invert()<CR>"
  else
    execute "nunmap <silent> <buffer> " . g:select_toggle_check_map
    execute "nunmap <silent> <buffer> " . g:select_invert_map
  endif
endfunction

" vim: set et sw=2
