" Sailor ftplugin
" Date: 06/06/2017 10:49:40 
" Author: Carlos Rubio Abujas <crubio.abujas@gmail.com>
" Description:
"   Set the file edit settings

""""""""""""""""""""""""""""""""""""
"    General file configuration    "
""""""""""""""""""""""""""""""""""""
set nowrap

nnoremap <buffer> <left> :w<CR>:execute ':edit '.FindPrevNote("%")<CR>
nnoremap <buffer> <right> :w<CR>:execute ':edit '.FindNextNote("%")<CR>
nnoremap <buffer> <leader>w :w<CR>:call SailorParseAll()<CR>
nnoremap <buffer> <localleader>t :call SailorToggleTags()<CR>

execute 'cd '.g:SailorNoteFolder 
