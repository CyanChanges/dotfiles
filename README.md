
# dotfiles

This repo contains the dotfiles of mine.

> [!IMPORTANT]  
> This project is still working in progress.
> Please report any BUG in [Issues](https://github.com/CyanChanges/dotfiles/issues)

## Requirements

Make sure `stow`, and `git` is installed
before using this repo.

Because i use [arch](https://archlinux.org) btw,
use `pacman` to install.

```sh
sudo pacman -S git stow
```

To run `.zpms.py`, you need following packages:

- zsh
- python
- python-rich
- python-typer
- python-colorama

```sh
pacman -S zsh python python-rich python-typer python-colorama
```

If you want to better completion,
instead of `zsh-users/zsh-completions`, install `carapace`

Because i use [arch](https://archlinux.org) btw,
use your AUR package manager (`paru`, `yay`, etc.)
to install `carapace-bin`

```sh
paru -S carapace-bin
```


## Quick Start

Please check out the [Requirements](#basic-requirements)  

Clone this repo in your `$HOME` directory using git:

```shell
git clone https://github.com/CyanChanges/dotfiles.git
cd dotfiles
```

Then, use `stow` to create symlinks:

```shell
stow .
```

Then, [Configure ZSH](#configure-zsh)

## Configure ZSH

Make sure `zsh` is installed:

```sh
sudo pacman -S zsh 
```

Following packages is required too:
```zsh
paru -S gnupg zoxide lsd
```

Run `z-pms.py` (See <#Requirements> above), to choice your favourite ZSH plugin manager.
See [Choice ZSH plugin managers](#zsh-plugin-managers) for more details.
I prefer [`zinit`](https://github.com/zdharma-continuum/zinit):

```shell
./.z-pms.py select zinit
```

Wait until the command complete,
run `zsh` to have a nice ZSH shell.

## ZSH Plugin Managers

I have configured some plugin managers out of box.
List of currently supported plugin managers and support status:

- [zinit](https://github.com/zdharma-continuum/zinit) **Recommended**
- [zimfw](https://github.com/zimfw/zimfw) **Good**
- [zplug](https://github.com/zplug/zplug) **Fair**
- [zpm](https://github.com/zpm-zsh/zpm) **Working In Progress**

## Completions


