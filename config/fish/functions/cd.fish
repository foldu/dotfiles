function cd
    if [ -z "$argv[1]" ]
        builtin cd ~
    else
        builtin cd "$argv[1]"
    end
    ls
end
