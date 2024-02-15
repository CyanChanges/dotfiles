if [[ "$LOAD_P10K" = 'external' || "$LOAD_P10K" = 'cfg' ]]; then
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

#curl https://raw.githubusercontent.com/kaplanelad/shellfirm/main/shell-plugins/shellfirm.plugin.zsh -o ~/.shellfirm-plugin.sh

eval "$(zoxide init zsh)"

#source ~/.shellfirm-plugin.sh

source ~/.completions.zsh
source ~/.ext.zsh

source "$HOME/.rye/env"

#eval $(ssh-agent)&>/dev/null


