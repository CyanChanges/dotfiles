
# dotfiles

This repo contains the dotfiles of mine.

> [!IMPORTANT]
> This project working in progress.

## Requirements

Make sure `stow` and `git` is installed
before using this repo.

Because of i use [arch](https://archlinux.org) btw,
so I use `pacman` to install `stow`.

```shell
sudo pacman -S git stow
```

## Quick Start

Please checkout the [Requirements](#requirements)  

Clone this repo in your `$HOME` directory using git:

```shell
git clone https://github.com/CyanChanges/dotfiles.git
cd dotfiles
```

Then, use `stow` to create symlinks:

```shell
stow .
```

Done!
