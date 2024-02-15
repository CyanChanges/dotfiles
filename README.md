
# dotfiles

This repo contains the dotfiles of mine.

> [!IMPORTANT]  
> This project is still working in progress.
> Please report any BUG in [Issues](https://github.com/CyanChanges/dotfiles/issues)

## Requirements

Make sure `python`, `python-rich`, `stow`, and `git` is installed
before using this repo.

Because i use [arch](https://archlinux.org) btw,
so I use `pacman` to install `stow`.

```shell
sudo pacman -S python python-rich python-colorama git stow
```

If you want to better [`carapace`](https://carapace.sh/) completion
instead of `zsh-users/zsh-completions`, install `carapace`

Because i use [arch](https://archlinux.org) btw,
so use your favourite AUR package manager (`paru`, `yay`, etc.)
to install `carapace-bin`

```shell
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

```shell
sudo pacman -S zsh 
```

Run `z-pms.py`, to choice your favourite ZSH plugin manager.
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


