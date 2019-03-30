function fish_prompt
    set -l color_cwd
    set -l suffix
    set -l prefix
    switch $USER
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '$'
    end

    if [ -n "$SSH_CONNECTION" ]
        set host (prompt_hostname)
        set prefix "$USER@$host "
    end
    echo -n -s (set_color $color_cwd) "$prefix" (prompt_pwd) " $suffix " (set_color normal)
end
