# tabtab source for pnpm package
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true


source /opt/miniconda/etc/profile.d/conda.sh


[ -f ~/.inshellisense/key-bindings.zsh ] && source ~/.inshellisense/key-bindings.zsh

autoload -U +X bashcompinit && bashcompinit

eval $(thefuck --alias)
eval "$(register-python-argcomplete pipx)"
eval "$(register-python-argcomplete keyring)"
