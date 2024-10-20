export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/1000}/ssh-agent.socket"
# eval $(ssh-agent) > /dev/null
#unset SSH_AGENT_PID
#if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
#  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
#fi

if [ -n "$TTY" ]; then
  export TTY=$(tty)
fi

export GPG_TTY=$TTY

if [ -f $HOME/.cache/ags/user/generated/terminal/sequences.txt ]; then
  /usr/bin/cat $HOME/.cache/ags/user/generated/terminal/sequences.txt >> $TTY
fi
# gpg-connect-agent updatestartuptty /bye >/dev/null

(eval $(shellclear --init-shell)) &> /dev/null

export EDITOR='nvim'

# Created by `pipx` on 2023-11-12 04:20:02
export PATH="$PATH:$HOME/.local/bin"

export PATH="$PATH:$HOME/go/bin"

if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi

if (( ${+commands[yarn]} )); then
  export PATH="$PATH:$(yarn global bin)"
fi

if [[ -d "$HOME/.local/share/JetBrains/Toolbox/scripts" ]]; then
export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
fi

if [[ -d "$HOME/.nix-profile/" ]]; then
export PATH="$PATH:$HOME/.nix-profile/bin"
fi

export LOAD_P10K=${LOAD_P10K:-"none"}

if [[ $LOAD_P10K = "external" || $LOAD_P10K = "instant-only" ]]; then
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi
