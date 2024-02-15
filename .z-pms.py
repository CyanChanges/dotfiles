#!/usr/bin/env python
import atexit
import functools
import sys
import os
import subprocess
from dataclasses import dataclass, field
from enum import StrEnum
from random import choice
from pathlib import Path
from datetime import date
from shlex import quote
from shelve import open as shelve_open
from typing import cast, Any, Annotated, Optional, Literal

# import redis
import typer
from rich import print
from rich.panel import Panel
from rich.text import Text


def as_any(obj: Any) -> Any:
    return cast(obj, Any)


@dataclass
class PM:
    base_script: Path
    name: Optional[str] = None
    ld_name: Optional[str] = None
    ld_path: Optional[Path] = None
    x_init_config: Path = field(init=False)
    x_prepare: Path = field(init=False)
    x_init: Path = field(init=False)
    x_cleanup: Path = field(init=False)

    def __post_init__(self):
        self.x_init_config = self.base_script.with_suffix(".config.zsh")
        self.x_prepare = self.base_script.with_suffix(".pre.zsh")
        self.x_init = self.base_script.with_suffix(".init.zsh")
        self.x_cleanup = self.base_script.with_suffix(".clean.zsh")
        if not self.ld_path and self.name:
            self.ld_path = self.base_script.parent / f"load-{self.name}.zsh"

    @classmethod
    def from_loader(cls, ld_name: str):
        return cls.from_name(name_from_loader(ld_name), ld_name=ld_name)

    @classmethod
    def from_name(cls, pm_name: str, *, ld_name: str = None, ld_path: Path = None):
        return cls(PMS_DIR / f".{pm_name}.zsh", name=pm_name, ld_name=ld_name, ld_path=ld_path)

    def print_if(self):
        if self.x_init.is_file():
            print(f"X PM Init:\t {self.x_init}")
        if self.x_prepare.is_file():
            print(f"X Pre Init:\t {self.x_prepare}")
        if self.x_cleanup.is_file():
            print(f"X Cleanup:\t {self.x_cleanup}")

    def print_all(self):
        print(f"X PM Init:\t {self.x_init if self.x_init.is_file() else 'N/A'}")
        print(f"X Pre Init:\t {self.x_prepare if self.x_prepare.is_file() else 'N/A'}")
        print(f"X Cleanup:\t {self.x_cleanup if self.x_cleanup.is_file() else 'N/A'}")

    def set_ldpath(self, ld_path: Path):
        self.ld_path = ld_path

    def exist(self):
        if self.ld_path:
            return self.ld_path.is_file()
        return self.base_script.exists() or self.x_init.is_file() or self.x_prepare.is_file() or self.x_cleanup.is_file()

    def cname(self):
        return f"[cyan]{self.name}[/]"

    def __eq__(self, other):
        if isinstance(other, PM):
            if other.exist() and self.exist():
                return self.base_script == other.base_script
        return False


class PMEnum(StrEnum):
    zinit = "zinit"
    zimfw = "zimfw"
    zplug = "zplug"
    zpm = "zpm"
    random = "random"
    daily = "daily"


def name_from_loader(ld_name: str) -> str:
    return ld_name.removeprefix("load-").removesuffix(".zsh")


app = typer.Typer()

KEY_TODAYS_PM = "z-pms-todays-pm"
KEY_LAST_DATE = "z-pms-last-date"

ZPM_ROOT = Path(__file__).parent.resolve()

HOME_DIR = Path(os.path.expanduser("~")).resolve()
PM_LOAD = ZPM_ROOT / ".pm-loader.zsh"
ZSHRC_PATH = ZPM_ROOT / ".zshrc"
PMS_DIR = ZPM_ROOT / Path(".z-pms/").resolve()
DISABLES_DIR = PMS_DIR / "disable"
DISABLES = DISABLES_DIR.read_text("u8").splitlines()
PMS_LOADERS = (*PMS_DIR.glob("load-*.zsh"),)

Path(typer.get_app_dir("z-pms")).mkdir(parents=True, exist_ok=True)

shelve = shelve_open(str(Path(typer.get_app_dir("z-pms")) / 'state.shelve'))


@functools.cache
def get_pms():
    return {
        name_from_loader(path.name): path
        for path in PMS_DIR.glob("./load-*.zsh")
        if name_from_loader(path.name) not in DISABLES
    }


def set_environ():
    os.environ["ZPMS_DIR"] = str(PMS_DIR.absolute())


def print_banner():
    banner = Panel(Text.assemble(
        ("ZshPMs", "cyan"),
        (' - ', "bright_black"),
        ("Use random plugin manager everyday", "blue")
    ))
    print(banner)


def print_env_info():
    print("Home path\t", HOME_DIR)
    print("ZPM Root path\t", ZPM_ROOT)
    print("Zshrc path\t", ZSHRC_PATH)
    print("PMs dir:\t", PMS_DIR)
    print("Available PMs:\t", " ".join(get_pms()))


def cdata(data: str | Any):
    # return f"[cyan]{data}[/]"
    return str(data)


@app.command()
def select(
        which_pm: Annotated[
            PMEnum, typer.Option(help="Chose specific pm", prompt="Which PM you prefer to use", show_choices=True)],
        use_relative: Annotated[bool, typer.Option(help="Use relative path instead of absolute")] = True,
        force: Annotated[bool, typer.Option("--force", "-f", help="Force reinit the pm")] = False
):
    """
    Select new zsh plugin manager

    If 'new_pm' is given, use it instead of a randomly chosen plugin manager
    """
    pms = get_pms()

    prev_pm_name = shelve.get(KEY_TODAYS_PM, None)

    last_date: date = shelve.get(KEY_LAST_DATE, date.min)
    todays_pm_name: str = (
        choice(tuple(pms.keys()))
        if which_pm == 'random' else which_pm
    )

    if (date.today() - last_date).days >= 1:
        shelve[KEY_LAST_DATE] = date.today()
        if which_pm == 'daily':
            todays_pm_name = choice(which_pm)

    pm_loader = pms[todays_pm_name]
    os.environ["ZPM_ROOT"] = str(ZPM_ROOT)

    pm = PM.from_name(todays_pm_name)

    shelve[KEY_TODAYS_PM] = todays_pm_name
    shelve.sync()

    prev_pm = PM.from_name(prev_pm_name)

    print("")

    if force or pm != prev_pm:
        print(f"Todays pm:\t {pm.cname()}")
        print(f"Located loader:\t {pm.ld_path}")
        pm.print_if()
        if prev_pm.exist():
            print(f"Previous PM:\t {prev_pm.cname()}")
            print(f"Located Loader:\t {cdata(prev_pm.ld_path)}")
            prev_pm.print_if()

        if prev_pm.x_cleanup and prev_pm.x_cleanup.is_file():
            print("Cleaning up previous PM...")
            subprocess.call(["/usr/bin/zsh", "-c", prev_pm.x_cleanup.read_text("u8")])

        if pm.x_init.is_file():
            print("Setting up new PM...")
            subprocess.call(["/usr/bin/zsh", "-c", pm.x_init.read_text("u8")])

    print(f"Updating {cdata(ZSHRC_PATH)}...")
    if not ZSHRC_PATH.is_file():
        ZSHRC_PATH.unlink(True)

    if use_relative:
        LD_PM_REL = PM_LOAD.relative_to(HOME_DIR)
        ROOT_REL = ZPM_ROOT.relative_to(HOME_DIR)
        PMS_REL = PMS_DIR.relative_to(HOME_DIR)
        X_INITC = pm.x_init_config.relative_to(HOME_DIR)

        ZSHRC_PATH.write_text(
            "\n".join(
                (
                    #   f"source ~/.z-headers.zsh\n"
                    f"export ZPM_ROOT=$HOME/{quote(str(ROOT_REL))}",
                    f"export ZPMS_DIR=$HOME/{quote(str(PMS_REL))}",
                    f"export ZPM_CUR_PM={quote(str(todays_pm_name))}",
                    (
                        f"source $HOME/{quote(str(X_INITC))}"
                        if pm.x_init_config.is_file()
                        else ""
                    ),
                    (
                        f"source {pm.base_script.read_text()}\n"
                        if pm.base_script.is_file()
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
                    f"export ZPM_CUR_PM={quote(str(todays_pm_name))}",
                    (
                        f"source {quote(str(pm.x_init_config))}"
                        if pm.x_init_config.is_file()
                        else ""
                    ),
                    (
                        f"source {pm.base_script.read_text()}\n"
                        if pm.base_script.is_file()
                        else ""
                             f"source {PM_LOAD}\n"
                             f"source {quote(str(ZPM_ROOT / '.z-footer.zsh'))}\n"
                    ),
                )
            )
        )

    PM_LOAD.unlink(True)
    PM_LOAD.symlink_to(pm_loader.relative_to(PM_LOAD.parent))

    print(f"Link {cdata(PM_LOAD)} -> {cdata(pm_loader)}")

    if (force or pm != prev_pm) and pm.x_prepare.is_file():
        print("Configure new PM...")
        subprocess.call(["/usr/bin/zsh", "-c", pm.x_prepare.read_text("u8")])

    print("Done!")


if __name__ == "__main__":
    print_banner()
    set_environ()
    app()

atexit.register(shelve.close)
