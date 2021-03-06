#!/usr/bin/env bash
# /etc/bash/bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]]; then
    # Shell is non-interactive.  Be done now!
    return
fi

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Disable completion when the input buffer is empty.  i.e. Hitting tab
# and waiting a long time for bash to expand all of $PATH.
shopt -s no_empty_cmd_completion

# Enable history appending instead of overwriting when exiting.  #139609
shopt -s histappend

# Save each command to the history file as it's executed.  #517342
# This does mean sessions get interleaved when reading later on, but this
# way the history is always up to date.  History is not synced across live
# sessions though; that is what `history -n` does.
# Disabled by default due to concerns related to system recovery when $HOME
# is under duress, or lives somewhere flaky (like NFS).  Constantly syncing
# the history will halt the shell prompt until it's finished.
#PROMPT_COMMAND='history -a'

# Change the window title of X terminals
#case ${TERM} in
#	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
#		PS1='\[\033]0;\u@\h:\w\007\]'
#		;;
#	screen*)
#		PS1='\[\033k\u@\h:\w\033\\\]'
#		;;
#	*)
#		unset PS1
#		;;
#esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?} # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs} ]] &&
    type -P dircolors >/dev/null &&
    match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color}; then
    # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
    if type -P dircolors >/dev/null; then
        if [[ -f ~/.dir_colors ]]; then
            eval "$(dircolors -b ~/.dir_colors)"
        elif [[ -f /etc/DIR_COLORS ]]; then
            eval "$(dircolors -b /etc/DIR_COLORS)"
        fi
    fi

    if [[ ${EUID} == 0 ]]; then
        PS1='\[\033[01;31m\]\u@\h \w #\[\033[00m\] '
    else
        PS1='\[\033[01;33m\]\u@\h \w $\[\033[00m\] '
    fi

    alias ls='ls --color=auto'
    alias grep='grep --colour=auto'
    alias egrep='egrep --colour=auto'
    alias fgrep='fgrep --colour=auto'
else
    if [[ ${EUID} == 0 ]]; then
        # show root@ when we don't have colors
        PS1+='\u@\h \W \$ '
    else
        PS1+='\u@\h \w \$ '
    fi
fi

for sh in /etc/bash/bashrc.d/*; do
    # shellcheck source=/dev/null
    [[ -r ${sh} ]] && source "${sh}"
done

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs sh

if [[ "$-" == *i* ]]; then
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
    bind -m emacs '"^P": history-search-backward'
    bind -m emacs '"^N": history-search-forward'
fi

export PROMPT_COMMAND='history -a'

# shellcheck source=/dev/null
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export EDITOR=vi
