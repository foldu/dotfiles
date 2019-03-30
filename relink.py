#!/usr/bin/env python3
from pathlib import Path
import shutil
import platform


def main():
    for path in Path(".").iterdir():
        if path.match("config"):
            for path in path.iterdir():
                link(path, expand_path("~/.config") / path.name)
        elif not path.match(".*") and not path.samefile(__file__):
            link(path, expand_path("~") / ("." + str(path)))
        elif path.match("swaygen.sh"):
            link(path, expand_path("~/.local/bin/swaygen"))


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
    if dest.exists():
        if dest.samefile(target):
            return
        elif dest.is_symlink():
            dest.unlink()
        else:
            backup(dest)

    dest.parent.mkdir(exist_ok=True)
    dest.symlink_to(target)
    print("{} -> {}".format(target, dest))


if __name__ == "__main__":
    main()
