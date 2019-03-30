function fish_right_prompt
    set stat "$status"
    if [ "$stat" -ne "0" ]
        echo -n (set_color red) "[$stat]" (set_color normal)
    end
end

