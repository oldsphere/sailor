" Sailor plugin
" Date: 15/06/2017 14:05:18 
" Author: Carlos Rubio Abujas <crubio.abujas@gmail.com>
"Description:
"   General Plugin functions

let g:SailorNoteFolder =expand('~/NavigationLog')
let g:SailorPluginPath = expand('<sfile>:p:h')
let g:SailorTagWindow = 0

"""""""""""""""""
"   Functions   "
"""""""""""""""""

function! SailorOpen()
    let fileName = strftime("%Y-%m-%d.expl")
    let folderName = toupper(strftime("%b%Y"))
    let path = expand('~/NavigationLog').'/'.folderName.'/'.fileName

    let isNew = !filereadable(path)

    execute 'edit! '.path
    if isNew
        call append('$',strftime('# %A %d %b %Y'))
    endif
 
    if !isNew
        call append('$','')
    endif

    call append('$',strftime('# -- %H:%M --'))
    call append('$','')
    execute 'normal G'
endfunction

function! FindPrevNote(noteName)
    " Expand the noteName
    if a:noteName ==# '%'
        let noteName = expand('%')
    else
        let noteName = expand(a:noteName)
    endif

    " Get a list of the available notes
    let listFiles = systemlist('find '.g:SailorNoteFolder.' -iname "*.expl"')
    call sort(listFiles, 's:FileSortFunction')

    " Match the next note
    let i = 0
    for fileName in listFiles
        if fileName =~# noteName
            if i-1 < 0
                return fileName
            else
                return listFiles[i-1]
            endif
        endif
        let i += 1
    endfor

    " If not match return the same name
    echom "No note \"".noteName."\" has been found!"
    return noteName
endfunction

function! FindNextNote(noteName)
    " Expand the noteName
    if a:noteName =~# '%'
        let noteName = expand('%')
    else
        let noteName = expand(a:noteName)
    endif

    " Get a list of the available notes
    let listFiles = systemlist('find '.g:SailorNoteFolder.' -iname "*.expl"')
    call sort(listFiles, 's:FileSortFunction')

    " Match the next note
    let i = 0
    for fileName in listFiles
        if fileName =~# noteName
            if i+1 >= len(listFiles)
                return noteName
            else
                return listFiles[i+1]
            endif
        endif
        let i += 1
    endfor

    " If not match return the same name
    return noteName
endfunction

function! s:FileSortFunction(file1, file2)
    let n1 = s:GetFileDate(a:file1) 
    let n2 = s:GetFileDate(a:file2) 

    return n1-n2
endfunction

function! s:GetFileDate(fileName)
    " Given a string get the date in the format YYYY-mm-dd and asign to it a
    " number to sort
     
    let day = matchstr(a:fileName,'\v\d{4}.\d{2}.\zs\d{2}\ze') 
    let month = matchstr(a:fileName,'\v\d{4}.\zs\d{2}\ze.\d{2}') 
    let year = matchstr(a:fileName,'\v\zs\d{4}\ze.\d{2}.\d{2}') 
    
    return str2nr(year.month.day)
endfunction

function! s:MatchAll(content,regexp)
    let matches = []
    let i = 0
    let m = 1 

    while !empty(m)
       let m = matchstr(a:content,a:regexp,0,i+1)
       if !empty(m)
           let matches += [m]
       end
    
       let i += 1
       if i > 10000
           echom "MatchAll loop overflow"
           return []
       endif
    endwhile

    return matches
endfunction

function! s:SailorGetTags()
    let c = 1
    let TagList = []
    while c <= line('$')
        let cline = getline(c)
        let TagList += s:MatchAll(cline,'\v\|\S[^\|]+\S\|')
        let c += 1
    endwhile
    return TagList
endfunction

function! SailorGetBookmarkTags()
    let l0 = line('.')
    silent execute "normal! ?\\v^- .\<CR>"
    let l = line('.')
    let TagList = [] 
    while l <= line('$')
        let  l += 1
        let cline = getline(l)
        let TagList += s:MatchAll(cline,'\v\|\S[^\|]+\S\|')
        if cline =~# '\v^\s*$'
            break
        endif
    endwhile

    silent execute "normal! ".l0."gg"
    return TagList
endfunction

function! SailorUpdateFile()
    " Update a specific files with a tag list
    call s:SailorUpdateTags()
    call s:SailorUpdateBookmarks()
    redraw!
    echo "File Updated!"
endfunction

function! s:SailorUpdateTags()
    let tagsPath = g:SailorNoteFolder.'/TAGS'
    let tagList = s:SailorGetTags()
    let explnr = bufnr('%')
    execute ':edit '.tagsPath
    call append('^',tagList)
    sort u
    w
    let tagsnr = bufnr('%')
    execute 'buffer '.explnr
    execute 'bdelete '.tagsnr
endfunction

function! s:SailorUpdateBookmarks()
    let bookmarkPath = g:SailorNoteFolder.'/BOOKMARKS'
    let l = 0
    let isBookmark = 0
    while l <= line('$')
        let cline = getline(l)
        if cline =~# '\v^\-' 
            if !s:SailorBookmarkExists(cline)
                let isBookmark = 1
            endif
        endif

        if isBookmark
            if cline =~# '^\s*$' 
                let isBookmark = 0
            endif
            execute 'silent !echo -e '.shellescape(cline).' >>'.bookmarkPath

            " Add the last separation line 
            if l == line('$')
                execute 'silent !echo -e "" >>'.bookmarkPath
            endif
        endif

        let l+=1
    endwhile
endfunction

function! s:SailorBookmarkExists(cbook)
    let bookmarkPath = g:SailorNoteFolder.'/BOOKMARKS'
    let explnr = bufnr('%')
    execute ':view '.bookmarkPath
    let existsBookmark =  search(a:cbook,'cW')
    let bookmarknr = bufnr('%') 
    execute 'buffer '.explnr
    execute 'bdelete '.bookmarknr 
    return existsBookmark
endfunction
 
function! SailorToggleTags()
    let tagfiles = expand('~/NavigationLog/TAGS')
    if g:SailorTagWindow
        let winnr = bufwinnr('TAGS')
        execute ':close! ' . winnr
        let g:SailorTagWindow = 0
    else
        execute 'vertical new TAGS'
        execute 'edit ' . tagfiles
        20 wincmd |
        let g:SailorTagWindow = 1
    endif
endfunction

function! SailorParseAll()
    silent execute '!'.g:SailorPluginPath.'/SailorParseAll.py'
    redraw!
endfunction
"
"""""""""""""""""
"   Commands    "
"""""""""""""""""
command! Sailor call SailorOpen()
