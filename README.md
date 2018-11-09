# Ack.vim Extension

_WIP: May be subject to breaking change at any time for any reason._

An extension for [ack.vim](https://github.com/mileszs/ack.vim)

Provides a command interface for manipulating the `ack/ag` command line.

## Commands

Commands ending in `Buffer` will set the command line for the
local buffer only. The first use of a `~Buffer` command will
copy the current global command line before altering it.

```
:AckShowCommand                Lists the current command line

:AckWipeBufferLocal            Wipes the buffer local command line.
                               Running :Ack in buffer now uses the global
                               settings.

:AckAddOption OPT [VALUE] ..   Adds one or more options to the command line
:AckAddOptionBuffer

:AckRemoveOption OPT ..        Removes one or more options form the command line
:AckRemoveOptionBuffer

:AckIgnore FILE|DIR ..         Adds one or more files or directories to be ignored
:AckIgnoreBuffer

:AckInclude FILE|DIR ..        Removes one or more files or directories from the
:AckIncludeBuffer              ignore list of the command line
```

## Options

All `g:` options can also be set in the `b:` scope.
All options are a space-separated string.

```
g:ack_exe                      Executable to use, typically ack or ag

g:ack_default_options          Options that are always on, and cannot be removed

g:ack_options                  Options that are on, but can be removed

g:ack_whilelisted_options      Options that are off, but can be added

g:ack_ignore_func              A funcref taking a file or directory name,
                               returning the option that ignores it.
                               Default:
                                 if g:ack_exe is 'ag':
                                 "--ignore NAME"

                                 if g:ack_exe is anything else:
                                 "--ignore-directory=NAME" or
                                 "--ignore-file=NAME"
                                 depending on whether NAME is a file or
                                 directory

                               If your 'g:ack_exe' uses other options, provide
                               a funcref.
```

