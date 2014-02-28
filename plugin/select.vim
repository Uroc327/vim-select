" File:         plugin/select.vim
" Description:  Checkbox selection for vim
" Author:       Constantin Runge <uroc327@cssbook.de>
" Version:      0.0.0

" check for v:version
if exists("g:loaded_select") || &cp
  finish
endif
let g:loaded_select = 1

" needed? ( || &cp)
let s:save_cpo = &cpo
set cpo&vim

" read checklist
" write checklist
" {,un}check
" put to stdout
" invert
" highlight {,un}checked

function! s:SetGlobalOptDefault(opt, val)
  if !exists('g:' . a:opt)
    let g:{a:opt} = a:val
  endif
endfunction

" set global defaults
call s:SetGlobalOptDefault('select_map_prefix', '<Leader>s')
call s:SetGlobalOptDefault('select_toggle_map', g:select_map_prefix . 't')
call s:SetGlobalOptDefault('select_toggle_check_map', '<Space>')
call s:SetGlobalOptDefault('select_invert_map', '<Leader>' . g:select_toggle_check_map)

" wrappers and mappings
command! -nargs=0 SelectToggle call select#SelectToggle()
command! -nargs=0 SelectEnable call select#SelectEnable()
command! -nargs=0 SelectDisable call select#SelectDisable()
execute "nnoremap <silent> " . g:select_toggle_map . " :call select#SelectToggle()<CR>"

let &cpo = s:save_cpo

" vim: set et sw=2:
