if [[ "$LOAD_P10K" = 'external' || "$LOAD_P10K" = 'cfg' ]]; then
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

#curl https://raw.githubusercontent.com/kaplanelad/shellfirm/main/shell-plugins/shellfirm.plugin.zsh -o ~/.shellfirm-plugin.sh

eval "$(zoxide init zsh)"
source /usr/share/doc/git-extras/git-extras-completion.zsh

export GOPATH=$HOME/go

#SAVEHIST=$HISTSIZE
setopt append_history
setopt share_history
setopt CORRECT
setopt NO_NOMATCH
setopt LIST_PACKED
setopt ALWAYS_TO_END
setopt GLOB_COMPLETE
setopt COMPLETE_ALIASES
setopt COMPLETE_IN_WORD
#source ~/.shellfirm-plugin.sh

source ~/.completions.zsh
source ~/.ext.zsh

# ~/.zshrc
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

if [[ -d "$HOME/.rye" ]]; then
  source "$HOME/.rye/env"
fi

#eval $(ssh-agent)&>/dev/null


