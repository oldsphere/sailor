" SailorTAGS syntax file
" Date: 15/06/2017 09:38:26 
" Author: Carlos Rubio Abujas <crubio.abujas@gmail.com>
" Description:
"   Highlight TAGS

if exists("b:current_syntax")
    finish
endif

syntax match sailorTag '\v\|[^\|]+\|'
highlight link sailorTag        Identifier

let b:current_syntax = "sailor"
