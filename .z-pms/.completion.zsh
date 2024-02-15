if (( ${+commands[carapace]} )); then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
  source <(carapace _carapace)
else
  if (( ${+commands[__pm_load_zsh_completions]} )); then
    _pm_load_users_zsh_completions
  else
    if [[ ! -d $ZPM_ROOT/.zsh_completions ]]; then
      git clone https://github.com/zsh-users/zsh-completions.git $ZPM_ROOT/.zsh_completions
    fi
    fpath=($ZPM_ROOT/.zsh-completions $fpath)
    rm -f ~/.zcompdump;
  fi
fi
