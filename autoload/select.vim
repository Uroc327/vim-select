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
  if !exists('b:select_active') || !b:select_active
    return
  endif

  " or do not use line= specifier to modify existing signs -> signs have to be
  " in all lines
  if s:IsSelected(line('.'))
    execute "sign unplace " . line('.') . " buffer=" . winbufnr(0)
    execute "sign place " . line('.') . " line=" . line('.') . " name=unticked buffer=" . winbufnr(0)
  else
    execute "sign unplace " . line('.') . " buffer=" . winbufnr(0)
    execute "sign place " . line('.') . " line=" . line('.') . " name=ticked buffer=" . winbufnr(0)
  endif
endfunction

function! select#Invert()
  if !exists('b:select_active') || !b:select_active
    return
  endif

  redir => l:signstr
  silent! execute "sign place buffer=" . winbufnr(0)
  redir END

  for line in filter(split(l:signstr, '\n'), 'v:val =~ "^ "')                 " split by newlines and use only lines starting with ' ' (   line=.. buffer=..)
    let l:infolist = matchlist(line, '\vline\=(\d+)\s*id\=(\S+)\s*name\=(\S+)')  " :h pattern
    if empty(l:infolist) | continue | endif
    if l:infolist[3] == 'ticked'
      execute "sign unplace " . line('.') . " buffer=" . winbufnr(0)
      execute "sign place " . line('.') . " line=" . line('.') . " name=unticked buffer=" . winbufnr(0)
    elseif l:infolist[3] == 'unticked'
      execute "sign unplace " . line('.') . " buffer=" . winbufnr(0)
      execute "sign place " . line('.') . " line=" . line('.') . " name=ticked buffer=" . winbufnr(0)
    endif
  endfor
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

  if match(l:signstr, 'line=' . a:line . '.*name=ticked') >= 0
    return 1
  else
    return 0
  endif
endfunction

function! s:SetActive(active)
  let b:select_active = a:active
  call s:UpdateMappings()
  call s:UpdateBuffer()
endfunction

" mappings for newline / line delete ??
function! s:UpdateMappings()
  if exists('b:select_active') && b:select_active
    execute "nnoremap <silent> <buffer> " . g:select_toggle_check_map . " :call select#ToggleCheck()<CR>"
    execute "nnoremap <silent> <buffer> " . g:select_invert_map . " :call select#Invert()<CR>"
  else
    execute "nunmap <silent> <buffer> " . g:select_toggle_check_map
    execute "nunmap <silent> <buffer> " . g:select_invert_map
  endif
endfunction

" save and restore format
function! s:UpdateBuffer()
  if exists('b:select_active') && b:select_active
    " do not show save prefix
  else
    " show save prefix
  endif
endfunction

execute "sign define ticked text=\u2612"
execute "sign define unticked text=\u2610"

" vim: set et sw=2:
