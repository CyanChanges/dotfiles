alias a="ip a"
alias neigh="ip neigh"
alias m="df -h"
alias sd="sudo"
alias balance="btrfs balance"

alias ptm="poetry"
alias Pb="poetry build"
alias Pd="pdm"

alias wiped="shred --verbose --random-source=/dev/urandom -n1 --zero"

alias pn="pnpm"

alias microsoft-edge-stable="echo Not a chance"
alias microsoft-edge="microsoft-edge-stable"

alias z-vi="bindkey -v"
alias z-ee="bindkey -e"

export TWORD="fuck microsoft"
export CWORD="FUCK MICROSOFT"

alias chrome-nix="NIXPKGS_ALLOW_UNFREE=1 nix-shell -p google-chrome --impure --run \"fcitx5 && nixGL google-chrome-stable\""

alias ff='fastfetch'

alias bt='btop'

alias ls='lsd'

export MANPAGER='nvim +Man!'

source "$HOME/.zimfw-git.zsh"

source "$HOME/.ext.utility.zsh"

alias pwsh="pwsh -NoLogo"

alias pass-get="pass tessen -p -f sk"

alias k-copy="kitty + kitten clipboard"
alias kopy="k-copy"

alias k-mpv="mpv --vo=kitty"

__MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

#wiped() {
#  shred --verbose --random-source=/dev/urandom -n1 --zero $@
#}

port_stats() {
  sudo ss -lptn "sport = :$1"
}

get_dyn_sha224() {
  return $(echo -n '$@' | shasum -a 224 | cut -c 1-56)
}

set_dyn_sha224() {
  curl -d 'secret=$0' -d 'ip=$1' https://dyn.addr.tools
}

d8sha512() {
  sha512sum $@ | cut -c 1-8
}

dyn_addr_token="酥怕四酷睿特密文awa"
#dyn_addr_token=$(echo -n '酥怕四酷睿特密文awa' | shasum -a 224 | cut -c 1-56)
update_dyn() {
  curl -d "secret=酥怕四酷睿特密文awa" https://dyn.addr.tools
}

alias sded="sudo $EDITOR"

#alias ipython_u='ipython -i -c "import utils; from utils import *"'

ipython_u() {
  local ext=""
  if [ $# -ge 1 ]; then
    for mod in $@
    do
      ext="${ext}from utils.$mod import *; "
    done
  fi
  ipython -i -c "import utils; from utils import *; $ext"
}

PYPI_BSP='--break-system-packages'

autoload -U colors && colors

red=$fg[red]
green=$fg[green]
orange=$fg[yellow]
blue=$fg[blue]
magenta=$fg[magenta]
cyan=$(tput setaf 6)
white=$fg[white]
gray=$fg[gray]

secondary=$(tput setaf 8)

aqua=$(tput setaf 12)

default=$fg[default]
reset=$(tput sgr0)


uprint() {
  print "${gray}[${blue}*${gray}] ${aqua}$@${reset}"
}

uprint_n() {
  print -n "${gray}[${blue}*${gray}] ${aqua}$@${reset}"
}

uprint_nl() {
  print "\n${gray}[${blue}O${gray}] ${aqua}$@${reset}"
}

uprint_nln() {
  print -n "\n${gray}[${blue}O${gray}] ${aqua}$@${reset}"
}

uprint_t() {
  while read line
  do
    uprint $line
  done
}

ucmd_print() {
  print "${secondary}\$ $@${reset}"
}

ucmd() {
  ucmd_print $@;
  (eval $@) 2>&1 1>/dev/null | uprint_t
}

ucmd_s() {
  print -n "${gray}[${cyan}S${gray}] "
  ucmd_print $@
  eval $@ &> /dev/null
}

OS_RELEASE=$(cat /etc/os-release | grep ID=)
if [[ $OS_RELEASE == *"arch"* ]]; then
  source $ZPM_ROOT/.ext.arch.zsh
fi

alias s_zshrc="source ~/.zshrc"

ext_update() {
  ucmd source $HOME/.ext.zsh
  source $HOME/.ext.zsh
  ucmd source $HOME/.ext.completions.zsh
  source $HOME/.ext.completions.zsh
}

if [[ -d $HOME/.utils ]]; then
  up_utils() {
  uprint "Updating the utils..."
    time ucmd_s "pip install $HOME/.utils/dist/$1 --force-reinstall $PYPI_BSP"
  }

  up_utils_start() {
    _inst_utils $1 && ipython_u
  }
  alias use_utils="ipython_u"
fi

preferN_ask() {
  read -q "RESULT?${gray}[${blue}?${gray}] ${aqua}$1 ${secondary}[y/N]${reset}"
  RESULT="$?"
  print "${reset}" 
  return $RESULT
}

to_wipe() {
  print "${orange}Super file remover"
  print "${secondary} - Secure, Single Platform, Fun! ${reset}"

  for file in $@; do
    if ! stat $file >/dev/null; then
      uprint "Aborted!"
      return 1
    fi;
  done

  if ! preferN_ask "Are you sure to wipe $# file(s)"; then
    #$new_line
    uprint "Aborted!"
    return 1
  fi
  #$new_line
  uprint "Wiping $@..."

  time (
    ucmd wiped $@ ; 
    ucmd wipe $@ ;
    uprint_nln "took"
  )

  #if read -q "BALANCE?Do you want to do btrfs balance [y/N]"; then
  #  btrfs balance
  #fi
  uprint "${green}Wiped $# file(s)"
  return 0
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

export LS_COLORS=$(vivid generate dracula)

source ~/.ext.completions.zsh

