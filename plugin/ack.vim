if !get(g:, 'loaded_ack', v:false)
  echohl WarningMsg | echomsg 'could not load Ack-extention, Ack not loaded' | echohl None
  finish
endif

if get(g:, 'loaded_ack_extension', v:false)
  finish
endif

command! -bang -nargs=* -complete=file
       \ Ack
       \ call ack#Intercept('ack#Ack', 'grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file
       \ AckAdd
       \ call ack#Intercept('ack#Ack', 'grepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file
       \ AckFromSearch
       \ call ack#Intercept('ack#AckFromSearch', 'grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file
       \ LAck
       \ call ack#Intercept('ack#Ack', 'lgrep<bang>', <q-args>)
command! -bang -nargs=* -complete=file
       \ LAckAdd
       \ call ack#Intercept('ack#Ack', 'lgrepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file
       \ AckFile
       \ call ack#Intercept('ack#Ack', 'grep<bang> -g', <q-args>)
command! -bang -nargs=* -complete=file
       \ AckWindow
       \ call ack#Intercept('ack#Ack', 'grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file
       \ LAckWindow
       \ call ack#Intercept('ack#Ack', 'lgrep<bang>', <q-args>)

command! AckShowCommand echo ack#Prg("\n")
command! AckWipeBufferLocal call ack#WipeBufferLocal()
command! -nargs=+ -complete=custom,ack#complete
       \ AckAddOption
       \ call ack#AddOption(v:false, <f-args>)
command! -nargs=+ -complete=custom,ack#complete
       \ AckAddOptionBuffer
       \ call ack#AddOption(v:true, <f-args>)
command! -nargs=+ -complete=custom,ack#complete
       \ AckRemoveOption
       \ call ack#RemoveOption(v:false, <f-args>)
command! -nargs=+ -complete=custom,ack#complete
       \ AckRemoveOptionBuffer
       \ call ack#RemoveOption(v:true, <f-args>)
command! -nargs=+ -complete=file
       \ AckIgnore
       \ call ack#Ignore(v:false, <f-args>)
command! -nargs=+ -complete=file
       \ AckIgnoreBuffer
       \ call ack#Ignore(v:true, <f-args>)
command! -nargs=+ -complete=custom,ack#complete
       \ AckInclude
       \ call ack#Include(v:false, <f-args>)
command! -nargs=+ -complete=custom,ack#complete
       \ AckIncludeBuffer
       \ call ack#Include(v:true, <f-args>)

let g:loaded_ack_extension = v:true
