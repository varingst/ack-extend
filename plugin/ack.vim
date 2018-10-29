if !get(g:, 'loaded_ack', v:false)
  echohl WarningMsg | echomsg 'could not load Ack-extention, Ack not loaded' | echohl None
  finish
endif

if get(g:, 'loaded_ack_extension', v:false)
  finish
endif

command! -bang -nargs=* -complete=file
       \ Ack
       \ call acke#Intercept('ack#Ack', 'grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file
       \ AckAdd
       \ call acke#Intercept('ack#Ack', 'grepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file
       \ AckFromSearch
       \ call acke#Intercept('ack#AckFromSearch', 'grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file
       \ LAck
       \ call acke#Intercept('ack#Ack', 'lgrep<bang>', <q-args>)
command! -bang -nargs=* -complete=file
       \ LAckAdd
       \ call acke#Intercept('ack#Ack', 'lgrepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file
       \ AckFile
       \ call acke#Intercept('ack#Ack', 'grep<bang> -g', <q-args>)
command! -bang -nargs=* -complete=file
       \ AckWindow
       \ call acke#Intercept('ack#Ack', 'grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file
       \ LAckWindow
       \ call acke#Intercept('ack#Ack', 'lgrep<bang>', <q-args>)

command! AckShowCommand echo acke#Prg("\n")
command! AckWipeBufferLocal call acke#WipeBufferLocal()
command! -nargs=+ -complete=custom,ack#complete
       \ AckAddOption
       \ call acke#AddOption(v:false, <f-args>)
command! -nargs=+ -complete=custom,ack#complete
       \ AckAddOptionBuffer
       \ call acke#AddOption(v:true, <f-args>)
command! -nargs=+ -complete=custom,ack#complete
       \ AckRemoveOption
       \ call acke#RemoveOption(v:false, <f-args>)
command! -nargs=+ -complete=custom,ack#complete
       \ AckRemoveOptionBuffer
       \ call acke#RemoveOption(v:true, <f-args>)
command! -nargs=+ -complete=file
       \ AckIgnore
       \ call acke#Ignore(v:false, <f-args>)
command! -nargs=+ -complete=file
       \ AckIgnoreBuffer
       \ call acke#Ignore(v:true, <f-args>)
command! -nargs=+ -complete=custom,ack#complete
       \ AckInclude
       \ call acke#Include(v:false, <f-args>)
command! -nargs=+ -complete=custom,ack#complete
       \ AckIncludeBuffer
       \ call acke#Include(v:true, <f-args>)

let g:loaded_ack_extension = v:true
