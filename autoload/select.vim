" File:         autoload/select.vim
" Description:  Checkbox selection for vim
" Author:       Constantin Runge <uroc327@cssbook.de>
" Version:      0.0.0

if exists("g:autoloaded_select") || &cp
  finish
endif
let g:autoloaded_select = 1

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

" unicode: \u2610 \u2611 \u2612
function! select#ToggleCheck()
  if s:IsSelected(line('.'))
    execute "sign unplace " . line('.') . " buffer=" . winbufnr(0)
  else
    execute "sign place " . line('.') . " line=" . line('.') . " name=ticked buffer=" . winbufnr(0)
  endif
endfunction

function! select#Invert()
endfunction

function! s:SetBufferOptDefault(opt, val)
  if !exists('b:' . a:opt)
    let b:{a:opt} = a:val
  endif
endfunction

function! s:IsSelected(line)
  redir => l:signstr
  silent! execute "sign place buffer=" . winbufnr(0)
  redir END

  let l:signdict = {}

  for line in filter(split(l:signstr, '\n'), 'v:val =~ "^[S ]"')                 " split by newlines and use only lines starting with 'S' (Signs for ...) or ' ' (   line=.. buffer=..)
    let l:infolist = matchlist(line, '\vline\=(\d+)\s*id\=(\S+)\s*name\=(\S+)')  " :h pattern
    if(!empty(l:infolist))
      let l:signdict[l:infolist[1]] = {
        \ 'id'   : l:infolist[2],
        \ 'name' : l:infolist[3],
        \ }
    endif
  endfor

  echoe l:signdict

  return 0
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

execute "sign define ticked text=\u2622"
execute "sign define unticked text=\u2620"

" vim: set et sw=2
