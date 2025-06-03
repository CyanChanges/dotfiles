if (( ${+commands[paru]} )); then
  do_update() {
    uprint "Start updating.."
    roll_all
    ext_update
    uprint "${green}Done! ${blue}Reloading zsh..."
    exec zsh
  }

  roll_all() {
    uprint "Rolling everything"
    time ucmd /usr/bin/paru --noconfirm -Syyu $@
  }
fi

compdef _paru roll_all

compdef _no_args do_update
compdef _no_args ext_update

