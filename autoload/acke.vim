
let s:var = {
  \ 'ignore':      'ack_ignore',
  \ 'opts':        'ack_options',
  \ 'unset':       'ack_unset_options',
  \ 'exe':         'ack_exe',
  \ 'allowed':     'ack_whitelisted_options',
  \ 'default':     'ack_default_options',
  \ 'ignore_func': 'ack_ignore_func',
  \}
call extend(s:, s:var)

" -- Interface -- {{{1

fun! acke#Prg(...) abort " {{{2
  " assembles and returns ack command
  let l:prg = [get(s:, s:exe)]
  call extend(l:prg, s:[s:default])
  call extend(l:prg, s:get(s:opts, [], b:, s:))
  call extend(l:prg, map(copy(s:get(s:ignore, [], b:, s:)), s:[s:ignore_func]))
  return join(l:prg, a:0 ? a:1 : ' ')
endfun

fun! acke#Intercept(func, ...) abort " {{{2
  let g:ackprg = acke#Prg()
  return call(a:func, a:000)
endfun

fun! acke#Ignore(buffer, ...) abort " {{{2
  let l:ignored = s:get_or_copy(a:buffer, s:ignore, b:, s:)
  call uniq(sort(extend(l:ignored, a:000)))
endfun

fun! acke#Include(buffer, ...) abort " {{{2
  let l:ignored = s:get_or_copy(a:buffer, s:ignore, b:, s:)
  let l:to_ignore = s:to_set(a:000)
  call uniq(sort(filter(l:ignored, '!has_key(l:to_ignore, v:val)')))
endfun

fun! acke#AddOption(buffer, ...) abort " {{{2
  let l:opts = s:get_or_copy(a:buffer, s:opts, b:, s:)
  let l:new_opts = []

  for l:arg in a:000
    if l:arg =~# '^-'
      call add(l:new_opts, l:arg)
    else
      let l:new_opts[-1] .= ' '.l:arg
    endif
  endfor

  call extend(l:opts, l:new_opts)
  call s:build_unset_opts(a:buffer ? b: : s:)
endfun

fun! acke#RemoveOption(buffer, ...) abort " {{{2
  let l:opts = s:get_or_copy(a:buffer, s:opts, b:, s:)
  let l:to_remove = s:to_set(a:000)
  let l:indices = []

  for l:i in range(len(l:opts))
    if has_key(l:to_remove, substitute(l:opts[l:i], '\([^\s]\+\)\s.*', '\1', ''))
      call insert(l:indices, l:i)
    endif
  endfor

  for l:i in l:indices
    call remove(l:opts, l:i)
  endfor

  call s:build_unset_opts(a:buffer ? b: : s:)
endfun

fun! acke#WipeBufferLocal() abort " {{{2
  exe "unlet! ".join(map([s:ignore, s:opts, s:unset], '"b:".v:val'), ' ')
endfun

fun! acke#complete(...) abort " {{{2
  let l:cmd = substitute(a:2, '.*\(Ack\w\+\).*', '\1', '')

  if l:cmd =~# 'Include'
    let l:key = s:ignore
  elseif l:cmd =~# 'AddOption'
    if !has_key(s:, s:unset)
      call s:build_unset_opts(s:)
    endif
    let l:key = s:unset
  elseif l:cmd =~# 'RemoveOption'
    let l:key = s:opts
  else
    return ""
  endif

  let l:completions = s:get_or_copy(l:cmd =~# 'Buffer', l:key, b:, s:)

  return join(l:completions, "\n")
endfun

" -- Private -- {{{1

fun! s:get_or_copy(expr, key, a, b) abort " {{{2
  " get entry by key from a (expr true) or b (expr false)
  " copies entry from b to a if not in a
  if a:expr
    if !has_key(a:a, a:key)
      let a:a[a:key] = copy(get(a:b, a:key, []))
    endif
    return a:a[a:key]
  endif

  if !has_key(a:b, a:key)
    let a:b[a:key] = []
  endif
  return a:b[a:key]
endfun

fun! s:parse_options(optstr) abort " {{{2
  let l:opts = []

  for l:word in type(a:optstr) is v:t_list ? a:optstr : split(a:optstr, ' ')
    if l:word =~# '--\?\w\+' || empty(l:opts)
      call add(l:opts, l:word)
    else
      let l:opts[-1] .= ' '.l:word
    endif
  endfor

  return l:opts
endfun

fun! s:build_unset_opts(scope) abort " {{{2
  let a:scope[s:unset] = s:difference(s:[s:allowed], get(a:scope, s:opts, []))
endfun

fun! s:get(key, default, ...) abort " {{{2
  for l:scope in a:000
    if has_key(l:scope, a:key)
      return l:scope[a:key]
    endif
  endfor
  return a:default
endfun

fun! s:to_set(list) abort " {{{2
  let l:set = {}

  for l:e in a:list
    let l:set[l:e] = v:true
  endfor

  return l:set
endfun

fun! s:difference(a, b) abort " {{{2
  " removes from a:
  " - duplicate elements
  " - elements in b
  let l:set = s:to_set(a:a)

  for l:e in a:b
    if has_key(l:set, l:e)
      call remove(l:set, l:e)
    endif
  endfor

  return sort(keys(l:set))
endfun

fun! s:ag_ignore(index, file) abort " {{{2
  return printf('--ignore %s', a:file)
endfun

fun! s:ack_ignore(index, file) abort " {{{2
  return isdirectory(a:file) ?
        \ printf('--ignore-directory=%s', a:file) :
        \ printf('--ignore-file=%s', a:file)
endfun

" -- TESTING -- {{{1

if get(g:, 'ack_extend_TESTING')
  nnoremap <SID> <SID>
  let s:sid = maparg('<SID>', 'n')

  function! S(func, ...) abort
    return call(s:sid.a:func, a:000)
  endfun

  function! CleanUp()
    exe "unlet! ".join(map(keys(s:var), '"b:".v:val." s:".v:val'), ' ')
  endfun
endif

" -- Setting from g: -- {{{1

" if g:ack_exe is unset, grab from g:ackprg assembled in ack.vim init
let s:[s:exe] = get(g:, s:exe, split(get(g:, 'ackprg', 'ag'), ' ')[0])
let s:[s:ignore_func] = get(g:, s:ignore_func, funcref(
                                                \ s:[s:exe] ==# 'ag' ?
                                                \ 's:ag_ignore' :
                                                \ 's:ack_ignore'))

let s:[s:default] = s:parse_options(get(g:, s:default,
      \ ' -s -H --nopager --nocolor --nogroup --column'))

let s:[s:allowed] = s:parse_options(get(g:, s:allowed,
      \ '--case --literal --follow'))

let s:[s:ignore] = get(g:, s:ignore, [])
let s:[s:opts] = s:parse_options(get(g:, s:opts, []))
