# Load locale
if status -l; and test -r /etc/locale.conf
    while read -l kv
        set -gx (string split "=" -- $kv)
    end </etc/locale.conf
end

set NPM_BIN "$HOME/.npm-packages/bin"
test -d "$NPM_BIN"; and set PATH $PATH $NPM_BIN

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

function git_branch
    #set -l git_branches (git branch -l ^/dev/null | sed -e "s/^\* //")
    set -l git_branches (git rev-parse --abbrev-ref HEAD ^/dev/null)
    set -l git_status (git status --porcelain ^/dev/null)
    set -l infocolor 4ca4b5
    set -l delimcolor blue
    set -l pathcolor red
    if test "$git_branches"
        set_color $delimcolor
        echo -n "("
        if test "$git_status"
            set_color $pathcolor
            echo -n "*"
        end
        set_color $infocolor
        echo -n "$git_branches"
        set_color $delimcolor
        echo -n ")"
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
    echo -n (git_branch)
    set_color $delimcolor
    echo -n "["
    set_color $infocolor
    echo -n (jobs | wc -l)
    set_color $delimcolor
    echo -n "]"
end
