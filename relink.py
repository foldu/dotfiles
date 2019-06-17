#!/usr/bin/env python3
from pathlib import Path
import shutil
import platform
import subprocess


def main():
    for path in Path(".").iterdir():
        if path.match("config"):
            for path in path.iterdir():
                if not path.match("mimeapps.list"):
                    link(path, expand_path("~/.config") / path.name)
        elif not path.match(".*") and not path.samefile(__file__):
            link(path, expand_path("~") / ("." + str(path)))
        elif path.match("swaygen.sh"):
            link(path, expand_path("~/.local/bin/swaygen"))

    # stop applications from daring to rewrite my mimeapps.list
    # or truncating it to zero bytes for no reason
    # (looking at you firefox)
    dest = expand_path("~/.config/mimeapps.list")
    if not dest.is_file():
        shutil.copy("config/mimeapps.list", dest)
        make_immutable(dest)


def expand_path(s):
    return Path(s).expanduser()


def backup(path):
    backup_path = Path(".bak")
    backup_path.mkdir(exist_ok=True)
    bak_name = backup_path / ("{}_{}".format(platform.node(), path.name))
    shutil.move(path, bak_name)


def link(target, dest):
    target = target.absolute()
    dest = dest.absolute()
    if dest.is_symlink():
        if dest.exists() and dest.samefile(target):
            return
        else:
            dest.unlink()
    elif dest.is_file() or dest.is_dir():
        backup(dest)

    dest.parent.mkdir(exist_ok=True)
    dest.symlink_to(target)
    print("{} -> {}".format(target, dest))


def make_immutable(path):
    if input("Making {} immutable, ok? ".format(path)) != "y":
        exit("Aborted")
    subprocess.run(["sudo", "chattr", "+i", str(path)], check=True)


if __name__ == "__main__":
    main()
