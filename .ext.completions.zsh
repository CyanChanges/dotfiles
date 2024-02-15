_no_args() {
  _arguments
}

_ipython_u() {
   #local state
  _arguments '*: :(maths decos hks misc)'
}

compdef _ipython_u ipython_u

compdef _sudo ucmd
compdef _sudo ucmd_s

if [[ -d $HOME/.utils ]]; then
  _up_utils() {
    local state
    _arguments '1: :->p'
    case $state in
      p)
      _describe 'command' "($(/usr/bin/ls $HOME/.utils/dist/$1))"
      ;;
    esac
  }
  compdef _up_utils up_utils
  compdef _up_utils up_utils_start
fi


