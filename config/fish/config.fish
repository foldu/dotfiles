# aliases/abbr
alias mv "mv -iv"
alias cp "cp -iv"
alias rm "rm -v"
alias pish bpython
alias fm "pcmanfm &"
alias murder "pkill --signal SIGKILL"
alias x "arr x"
alias feil file

if type -q nvim
    alias vi nvim
    alias vim nvim
else if type -q vim
    alias vi vim
end

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
set -x RUST_SRC_PATH "/usr/src/rust/src"
set -x LESS '-g -i -M -R -w -X'
set -x MAKEFLAGS "-j "(nproc)
set -x QT_QPA_PLATFORMTHEME qt5ct
set -x FZF_DEFAULT_COMMAND 'rg --files'

# PATH
set -U fish_user_paths "$HOME/.cargo/bin" "$HOME/.local/bin"

# colors
set fish_color_param gray
set fish_color_operator cyan
set fish_pager_color_prefix gray

# disable greeting
set fish_greeting

# https://gist.github.com/gerbsen/5fd8aa0fde87ac7a2cae
# shit's bugged
setenv SSH_ENV $HOME/.ssh/environment

function start_agent
    echo "Initializing new SSH agent ..."
    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
    echo "succeeded"
    chmod 600 $SSH_ENV
    . $SSH_ENV > /dev/null
    ssh-add
end

function test_identities
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $status -eq 0 ]
        ssh-add
        if [ $status -eq 2 ]
            start_agent
        end
    end
end

if [ -n "$SSH_AGENT_PID" ]
    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    end
else
    if [ -f $SSH_ENV ]
        . $SSH_ENV > /dev/null
    end
    # here
    ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    else
        start_agent
    end
end
