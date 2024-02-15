#!/usr/bin/env python
import sys
import os
import subprocess
from random import choice
from pathlib import Path
from datetime import date
from shlex import quote
from typing import Any

import redis
from rich import print


def as_any(obj: Any) -> Any:
    return obj


def name_from_loader(ld_name: str) -> str:
    return ld_name.removeprefix("load-").removesuffix(".zsh")


USE_RELATIVE = True
KEY_TODAYS_PM = "z-pms-todays-pm"
KEY_LAST_DATE = "z-pms-last-date"

storage = redis.Redis("127.0.0.1", 6379, 0, None)


ZPM_ROOT = Path(".").resolve()

HOME_DIR = Path(os.path.expanduser("~")).resolve()
PM_LOAD = ZPM_ROOT / ".pm-loader.zsh"
ZSHRC_PATH = ZPM_ROOT / ".zshrc"
PMS_DIR = ZPM_ROOT / Path(".z-pms/").resolve()
DISABLES_DIR = PMS_DIR / "disable"
DISABLES = DISABLES_DIR.read_text("u8").splitlines()
PMS_LOADERS = (*PMS_DIR.glob("load-*.zsh"),)

PMS = {
    name_from_loader(path.name): path
    for path in PMS_DIR.glob("./load-*.zsh")
    if name_from_loader(path.name) not in DISABLES
}
os.environ["ZPMS_DIR"] = str(PMS_DIR.absolute())

print("[bright_black]" + "-" * 40 + "[/bright_black]")
print("[cyan]ZshPMs[/] [bright_black]-[/] [blue]Use random package manager everyday[/]")
print("[bright_black]" + "-" * 40 + "[/bright_black]")

print("Home path\t", HOME_DIR)
print("ZPM Root path\t", ZPM_ROOT)
print("Zshrc path\t", ZSHRC_PATH)
print("PMs dir:\t", PMS_DIR)
print("Availiable PMs:\t", " ".join(PMS))

selected = None
if len(sys.argv[1:]) >= 1:
    selected = sys.argv[1]

prev_pm = as_any(storage.get(KEY_TODAYS_PM) or b"").decode()
X_PREV = PMS.get(prev_pm, None)

last_date: date = date.fromisoformat(
    as_any(storage.get(KEY_LAST_DATE)).decode("u8")
) or date.fromordinal(0)
todays_pm: str = (
    selected
    or as_any(storage.get(KEY_TODAYS_PM) or b"").decode()
    or choice(tuple(PMS.keys()))
)

if (date.today() - last_date).days >= 1:
    storage.set(KEY_LAST_DATE, date.today().isoformat())
    todays_pm = choice(tuple(PMS.keys()))

pm_loader = PMS[todays_pm]
os.environ["ZPM_ROOT"] = str(ZPM_ROOT)

PM_SCRIPT = PMS_DIR / f".{todays_pm}.zsh"

X_INIT_CONFIG = PM_SCRIPT.with_suffix(".config.zsh")
X_PRE_INIT = PM_SCRIPT.with_suffix(".pre.zsh")
X_INIT = PM_SCRIPT.with_suffix(".init.zsh")
X_CLEANUP = PM_SCRIPT.with_suffix(".clean.zsh")

storage.set(KEY_TODAYS_PM, todays_pm)

X_PREV_SCRIPT = PMS_DIR / f".{prev_pm}.zsh"
X_PREV_CLEANUP = None

if prev_pm:
    print("Previous PM:\t", prev_pm)
    X_PREV_CLEANUP = X_PREV_SCRIPT.with_suffix(".clean.zsh")

print(f"Todays pm:\t {todays_pm}")
print(f"Located loader:\t {pm_loader}")
print("")

if X_INIT.is_file():
    print(f"X PM Init:\t {X_INIT}")
if X_PRE_INIT.is_file():
    print(f"X Pre Init:\t {X_PRE_INIT}")
if X_CLEANUP.is_file():
    print(f"X Cleanup:\t {X_CLEANUP}")

if X_PREV_CLEANUP and X_PREV_CLEANUP.is_file():
    print("Cleaning up previous PM...")
    subprocess.call(["/usr/bin/zsh", "-c", X_PREV_CLEANUP.read_text("u8")])

if X_INIT.is_file():
    print("Setting up new PM...")
    subprocess.call(["/usr/bin/zsh", "-c", X_INIT.read_text("u8")])

print(f"Updating {ZSHRC_PATH}...")
if not ZSHRC_PATH.is_file():
    ZSHRC_PATH.unlink(True)

if USE_RELATIVE:
    LD_PM_REL = PM_LOAD.relative_to(HOME_DIR)
    ROOT_REL = ZPM_ROOT.relative_to(HOME_DIR)
    PMS_REL = PMS_DIR.relative_to(HOME_DIR)
    X_INIT_REL = X_INIT_CONFIG.relative_to(HOME_DIR)

    ZSHRC_PATH.write_text(
        "\n".join(
            (
                #   f"source ~/.z-headers.zsh\n"
                f"export ZPM_ROOT=$HOME/{quote(str(ROOT_REL))}",
                f"export ZPMS_DIR=$HOME/{quote(str(PMS_REL))}",
                f"export ZPM_CUR_PM={quote(str(todays_pm))}",
                (
                    f"source $HOME/{quote(str(X_INIT_REL))}"
                    if X_INIT_CONFIG.is_file()
                    else ""
                ),
                (
                    f"source {PM_SCRIPT.read_text()}\n"
                    if PM_SCRIPT.is_file()
                    else ""
                    f"source $HOME/{LD_PM_REL}\n"
                    f"source $HOME/{quote(str(ROOT_REL / '.z-footer.zsh'))}\n"
                ),
            )
        )
    )
else:
    ZSHRC_PATH.write_text(
        "\n".join(
            (
                #   f"source ~/.z-headers.zsh\n"
                f"export ZPM_ROOT={quote(str(ZPM_ROOT))}",
                f"export ZPMS_DIR={quote(str(PMS_DIR))}",
                f"export ZPM_CUR_PM={quote(str(todays_pm))}",
                (
                    f"source {quote(str(X_INIT_CONFIG))}"
                    if X_INIT_CONFIG.is_file()
                    else ""
                ),
                (
                    f"source {PM_SCRIPT.read_text()}\n"
                    if PM_SCRIPT.is_file()
                    else ""
                    f"source {PM_LOAD}\n"
                    f"source {quote(str(ZPM_ROOT / '.z-footer.zsh'))}\n"
                ),
            )
        )
    )


PM_LOAD.unlink(True)
os.symlink(str(pm_loader), PM_LOAD)

print(f"Link {PM_LOAD} -> {pm_loader}")


if X_PRE_INIT.is_file():
    print("Configure new PM...")
    subprocess.call(["/usr/bin/zsh", "-c", X_PRE_INIT.read_text("u8")])

print("Done!")
