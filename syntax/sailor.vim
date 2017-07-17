" Sailor syntax file
" Date: 06/06/2017 10:49:40 
" Author: Carlos Rubio Abujas <crubio.abujas@gmail.com>
" Description:
"   Highlight the URL, bookmarks and tags

if exists("b:current_syntax")
    finish
endif

syntax match sailorURL '\vhttps?://.+$'
syntax match sailorComment '\v^#.+$'
syntax match sailorBookmark '\v^[-*+]\s.+'
syntax match sailorTag '\v\|[^\|]+\|'
syntax match sailorNote '\v[nN][oO][tT][eEaA]:.+$'

highlight link sailorURL        Underlined 
highlight link sailorBookmark   Type
highlight link sailorComment    Comment
highlight link sailorTag        Identifier
highlight link sailorNote       Todo

let b:current_syntax = "sailor"
