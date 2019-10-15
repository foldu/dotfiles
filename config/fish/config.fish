# aliases/abbr
alias mv "mv -iv"
alias cp "cp -iv"
alias rm "rm -v"
alias fm "pcmanfm &"
alias murder "pkill --signal SIGKILL"
alias x "arr x"
alias feil file

alias iv iv2

if type -q nvim
    alias vi nvim
    alias vim nvim
else if type -q vim
    alias vi vim
end

abbr -a c cargo
abbr -a ap ansible-playbook
abbr -a aping ansible all -m ping
alias rsync "rsync --info=progress2 --human-readable"

# os specific aliases/abbr
switch (uname)
    case Linux
        set os (perl -ne 'if (/^ID="?(\w+)"?/) {print "$1\n"}' /etc/os-release)
        # lmao no nested switches
        if [ "$os" = "arch" ]
            abbr -a "paci" "sudo pacman -S"
            abbr -a "pacI" "sudo pacman -U"
            abbr -a "pacx" "sudo pacman -R"
            abbr -a "pacX" "sudo pacman -Rs"
            abbr -a "pacs" "pacaur -Ss"
            abbr -a "pacq" "pacman -Si"
            abbr -a "pacQ" "pacman -Qi"
            abbr -a "aur" "pacaur"
            alias pacu "sudo pacman -Syu"
            alias pacU "sudo pacman -Sy"
        else if [ "$os" = "centos" ]
            abbr -a "dni" "sudo yum install"
            abbr -a "dnr" "sudo yum remove"
            alias dnu "yum update"
        end
        set -e os

        alias grep='grep --color=auto'

        abbr -a sv "sudo systemctl"
        abbr -a usv "systemctl --user"
    case FreeBSD
        abbr -a pkgi "sudo pkg install"
        abbr -a pkgr "sudo pkg remove"
end

# bind edit_command_buffer to the same kb as bash
bind \cx\ce edit_command_buffer

# prompt
set -g fish_color_cwd yellow
set -g fish_prompt_pwd_dir_length 0

# env vars
set -x EDITOR nvim
set -x PAGER less
set -x TERMINAL alacritty
set -x BROWSER firefox-developer-edition
set -x LESS '-g -i -M -R -w -X'
set -x MAKEFLAGS "-j "(nproc)
set -x QT_QPA_PLATFORMTHEME qt5ct
set -x FZF_DEFAULT_COMMAND 'rg --files'

# PATH
set -U fish_user_paths "$HOME/.cargo/bin" "$HOME/.local/bin"

# disable greeting
set fish_greeting

# colors
# this basically is the solarized theme painfully extracted with PERL magic
# because the web config just puts it in universal variables that I certainly
# don't want to put in my dotfiles. Too bad that I also don't know the escaping
# rules for universal variables, would've been much easier

# the default color
set fish_color_normal normal

# the color for commands
set fish_color_command 586e75

# the color for quoted blocks of text
set fish_color_quote 839496

# the color for IO redirections
set fish_color_redirection 6c71c4

# the color for process separators like ';' and '&'
set fish_color_end 268bd2

# the color used to highlight potential errors
set fish_color_error dc322f

# the color for regular command parameters
set fish_color_param 657b83

# the color used for code comments
set fish_color_comment 93a1a1

# the color used to highlight matching parenthesis
set fish_color_match --background=brblue

# the color used when selecting text (in vi visual mode)
set fish_color_selection white --bold --background=brblack

# used to highlight history search matches and the selected pager item
# (must be a background)
set fish_color_search_match bryellow --background=white

# the color for parameter expansion operators like '*' and '~'
set fish_color_operator 00a6b2

# the color used to highlight character escapes like '\\n' and '\\x70'
set fish_color_escape 00a6b2

# the color used for autosuggestions
set fish_color_autosuggestion 93a1a1

# the color for the '^C' indicator on a canceled command
set fish_color_cancel -r

# the color of the progress bar at the bottom left corner
set fish_pager_color_progress brwhite --background=cyan

# the background color of a line
#set fish_pager_color_background

# the color of the prefix string, i.e. the string that is to be completed
set fish_pager_color_prefix cyan --underline

# the color of the completion itself
set fish_pager_color_completion green

# the color of the completion description
set fish_pager_color_description B3A06D

# fish_pager_color_background of every second unselected completion.
#set fish_pager_color_secondary_background

# fish_pager_color_prefix of every second unselected completion.
#set fish_pager_color_secondary_prefix

# fish_pager_color_completion of every second unselected completion.
#set fish_pager_color_secondary_completion

# fish_pager_color_description of every second unselected completion.
#set fish_pager_color_secondary_description

# fish_pager_color_background of the selected completion.
#set fish_pager_color_selected_background

# fish_pager_color_prefix of the selected completion.
#set fish_pager_color_selected_prefix

# fish_pager_color_completion of the selected completion.
#set fish_pager_color_selected_completion

# fish_pager_color_description of the selected completion.
#set fish_pager_color_selected_description
