" Sailor ftplugin
" Date: 15/06/2017 09:35:03 
" Author: Carlos Rubio Abujas <crubio.abujas@gmail.com>
" Description:
"   Set TAGS file settings

nnoremap <buffer> <localleader>t :call SailorTagsClose()<CR>
nnoremap <buffer> <leader>q :call SailorTagsClose()<CR>
nnoremap <buffer> <localleader>q :call SailorTagsClose()<CR>
nnoremap <buffer> <localleader>r :call SailorNewSearch()<CR>
nnoremap <buffer> <localleader>f :call SailorApplyFilter(expand("<cWORD>"))<CR>
nnoremap <buffer> <localleader>g :call SailorFindTag(expand("<cWORD>"))<CR>

"""""""""""""""""""
"    Functions    "
"""""""""""""""""""
function! SailorTagsClose()
    let g:SailorTagWindow = 0
    quit!
endfunction

function! s:OpenInWindow(nr,fileName)
     let initial_nr = bufnr('%')
     let current_nr = -1
     while current_nr != initial_nr 
        wincmd w
        let current_nr = bufnr('%')

        if current_nr == a:nr
            execute 'edit! '.a:fileName
            return 1
        endif
     endwhile
     return 0
endfunction

function! SailorOpenSearch()
    let explnr = s:GetOpennr('expl$')
    let searchFile = g:SailorNoteFolder. '/LASTSEARCH'
    if !s:OpenInWindow(explnr,searchFile)
        let explnr = bufnr('LASTSEARCH')
        call s:OpenInWindow(explnr,searchFile)
    endif
    call s:FocusWindow(bufnr('TAGS'))
endfunction

function! s:GetOpennr(expr)
    let initial_nr = bufnr('%')
    let current_nr = -1
    while current_nr != initial_nr
        wincmd w
        let current_nr = bufnr('%')
        if bufname(current_nr) =~# a:expr
            return current_nr
        endif
    endwhile
    return -1
endfunction

function! SailorNewSearch()
    let bookmarkFile = g:SailorNoteFolder. '/BOOKMARKS'
    let searchFile = g:SailorNoteFolder. '/LASTSEARCH'  
    silent execute '!cp '.bookmarkFile. ' '.searchFile
    redraw!
    call SailorOpenSearch()
endfunction

function! s:RemoveBookmark()
    if getline('.') !~# '\v^- .'
        silent! execute "normal! ?\\v^- .\<CR>>"
    endif

    let l0 = line('.')
    silent! execute "normal! /\\v^\\s*$\<CR>"
    let lf = line('.')
    
    if lf <= l0
        let lf = line('$')
    endif
    
    silent! execute l0.','.lf.'d' 
endfunction

function! SailorApplyFilter(tag)
    silent call SailorOpenSearch()
    call s:FocusWindow(bufnr('LASTSEARCH'))
    let defaultWrapScan = &wrapscan
    set wrapscan
    silent! execute ":normal! gg"
    silent! execute ":normal! /\\vhttps?\<CR>"
    let l0 = -1
    let l1 = 1
    while getline(l0) !=# getline(l1)
        let tagsList = SailorGetBookmarkTags()
        if index(tagsList,a:tag) == -1
            silent call s:RemoveBookmark()
        else
            if l0 < 0
                let l0 = line('.')
            endif
        endif
        silent! execute ":normal! /\\vhttps?\<CR>"
        let l1 = line('.')
    endwhile
    w
    let &wrapscan = defaultWrapScan
    call s:FocusWindow(bufnr('TAGS'))
endfunction

function! s:FocusWindow(nr)
    let initial_nr = bufnr('%')
    let current_nr = -1
    while current_nr != initial_nr
        wincmd w
        let current_nr = bufnr('%')
        if current_nr == a:nr
            return 1
        endif
    endwhile
    return 0
endfunction

function! SailorFindTag(tag)
    wincmd w
    execute ':silent lgrep -R '.shellescape(escape(a:tag, '|')).' **/*.expl'
    lopen 5
    wincmd k
    redraw!
endfunction!
