# Load locale
if status -l; and test -r /etc/locale.conf
    while read -l kv
        set -gx (string split "=" -- $kv)
    end </etc/locale.conf
end

# start X at login
if status --is-login
    if test -z "$DISPLAY" -a $XDG_VTNR -eq 1
        exec startx -- -keeptty
    end
end

# Load aliases
if test -f ~/.config/fish/aliases.fish
    . ~/.config/fish/aliases.fish
end

function fish_greeting
end

function prompt_dir
    if test $PWD != $HOME
        printf "%s" (basename $PWD)
    else
        printf "~"
    end
end

function fish_prompt
    set -l infocolor 4ca4b5
    set -l delimcolor blue
    set -l pathcolor red
    set_color $infocolor
    echo -n (basename $USER)
    set_color $delimcolor
    echo -n "@"
    set_color $infocolor
    echo -n (hostname)
    set_color $pathcolor
    echo -n " "(prompt_dir)" "
    set_color $delimcolor
    echo -n "❯ "
end

function fish_right_prompt
    set -l delimcolor blue
    set -l infocolor 4ca4b5
    set_color $delimcolor
    echo -n "["
    set_color $infocolor
    echo -n (jobs | wc -l)
    set_color $delimcolor
    echo -n "]"
end
