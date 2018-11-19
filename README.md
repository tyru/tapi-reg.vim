# tapi-reg.vim

Seamless vim register manipulation in :terminal via terminal-api

# Setup

In your .bashrc

```
source <this repo>/macros/vimreg.sh
```

# `:terminal` --> Vim: send string to vim register

Then now you can get `vimreg` command.
It can access to vim registers from `:terminal` buffer.

In `:terminal` buffer, type

```
$ echo 'send this text to vim register!' | vimreg
```

Then your vim's unnamed register has been set to above text.

Also you can specify register name.

```
$ echo 'send this text to register a!' | vimreg a
```

`vimreg` gets text from standard input, so of course you can

```
$ vimreg
This
is
sent
to
vim
register.
^D
$
```

# Vim --> `:terminal`: get vim register content

`vimreg` supports `--get` or `-g` option.
It shows given vim register's content to output.
If a register name was not given, the default register name is `"` (unnamed register).

```
$ vimreg -g
Hello this is vim unnamed register content.
$ vimreg -g a
this is "a" register content.
```

And also it can list all vim register contents (same as `:registers` output).

```
$ vimreg -l
--- Registers ---
""   --- Registers ---^J""   ^J^J"0       if a:args[1] ==# '--list'^J^J"1   ^J^J"2       if a:args[1] =~# '\v^(-l|--list)$'^J^J"3     local reg='"'^J^J"4     set +x^J^J"5     set -x^J^J"6     set -x^J^J"7  
"0   --- Registers ---^J""   ^J^J"0       if a:args[1] ==# '--list'^J^J"1   ^J^J"2       if a:args[1] =~# '\v^(-l|--list)$'^J^J"3     local reg='"'^J^J"4     set +x^J^J"5     set -x^J^J"6     set -x^J^J"7  
"1   ^J
"2       if a:args[1] =~# '\v^(-l|--list)$'^J
"3     local reg='"'^J
"4     set +x^J
"5     set -x^J
"6     set -x^J
"7       content=^J
"8       printf '\e]51;["call","Tapi_reg",["set",%s,%s]]\x07' \^J        "$(to_json_string "$reg")" "$(to_json_string "$content")"^J
"9   $(to_json_string "$3")
"a   degure
"s   "
"-   $list || 
".   --list
":   call system('clip.exe', execute('registers'))
"%   macros/vimreg.sh
"#   plugin/tapi_reg.vim
"/   --list
```
