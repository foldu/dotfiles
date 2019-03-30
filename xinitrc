#!/bin/sh
if [ -d /etc/X11/xinit/xinitrc.d  ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?* ; do
        [ -x "$f"  ] && . "$f"
    done
    unset f
fi

[ -f ~/.xprofile ] && . ~/.xprofile


session=${1:-awesome}

case $session in
    awesome           ) exec awesome;;
    catwm             ) exec catwm;;
    cinnamon          ) exec cinnamon-session;;
    dwm               ) exec dwm;;
    bspwm             )
        sxhkd&
        exec bspwm;;
    enlightenment     ) exec enlightenment_start;;
    ede               ) exec startede;;
    fluxbox           ) exec startfluxbox;;
    gnome             ) exec gnome-session;;
    gnome-classic     ) exec gnome-session --session=gnome-classic;;
    i3                ) exec i3;;
    icewm             ) exec icewm-session;;
    jwm               ) exec jwm;;
    mate              ) exec mate-session;;
    monster|monsterwm ) exec monsterwm;;
    notion            ) exec notion;;
    openbox           ) exec openbox-session;;
    unity             ) exec unity;;
    xfce              ) exec startxfce4;;
    xmonad            ) exec xmonad;;
    plasma            ) exec startkde;;
    emacs             ) exec emacs --fullscreen;;
    lxqt              ) exec startlxqt;;
    # No known session, try to run it as command
    *) exec "$1";;
esac
