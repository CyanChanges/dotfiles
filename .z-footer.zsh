if [[ "$LOAD_P10K" = 'external' || "$LOAD_P10K" = 'cfg' ]]; then
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

#curl https://raw.githubusercontent.com/kaplanelad/shellfirm/main/shell-plugins/shellfirm.plugin.zsh -o ~/.shellfirm-plugin.sh

eval "$(zoxide init zsh --no-aliases)"
alias z="__zoxide_z"
alias '$'="__zoxide_zi"

export GOPATH=$HOME/go

#SAVEHIST=$HISTSIZE
setopt interactivecomments
setopt append_history
setopt share_history
setopt no_nomatch
setopt list_packed
setopt glob_complete
setopt complete_aliases
setopt complete_in_word
#source ~/.shellfirm-plugin.sh

snippet ~/.completions.zsh
snippet ~/.ext.zsh

alias enable_correct="setopt correct"

# ~/.zshrc
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

if [[ -d "$HOME/.rye" ]]; then
  snippet "$HOME/.rye/env"
fi

#eval $(ssh-agent)&>/dev/null


