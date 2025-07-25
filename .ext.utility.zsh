#
# Utility aliases and settings
#

# ASDF Manager
#if [[ -f /opt/asdf-vm/asdf.sh ]]; then
#  . /opt/asdf-vm/asdf.sh
#fi

if (( ${+commands[sccache]} )); then
  export SCCACHE="${commands[sccache]}"
fi

# Set less or more as the default pager.
if (( ! ${+PAGER} )); then
  if (( ${+commands[less]} )); then
    export PAGER=less
  else
    export PAGER=more
  fi
fi

if (( ! ${+LESS} )); then
  export LESS='--chop-long-lines --ignore-case --jump-target=4 --LONG-PROMPT --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
fi

#
# File Downloads
#

# order of preference: aria2c, axel, wget, curl. This order is derrived from speed based on personal tests.
if (( ${+commands[aria2c]} )); then
  alias get='aria2c --max-connection-per-server=5 --continue'
elif (( ${+commands[axel]} )); then
  alias get='axel --num-connections=5 --alternate'
elif (( ${+commands[wget]} )); then
  alias get='wget --continue --progress=bar --timestamping'
elif (( ${+commands[curl]} )); then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
fi


alias cat="bat"

#
# Resource Usage
#

alias df='df -h'
alias du='du -h'


#
# Colours
#

if (( terminfo[colors] >= 8 )); then
  # grep colours
  if (( ! ${+GREP_COLOR} )) export GREP_COLOR='37;45'               #BSD
  if (( ! ${+GREP_COLORS} )) export GREP_COLORS="mt=${GREP_COLOR}"  #GNU
  if [[ ${OSTYPE} == openbsd* ]]; then
    if (( ${+commands[ggrep]} )) alias grep='ggrep --color=auto'
  elif (( ${+commands[grep]} )); then
    alias grep='grep --color=auto'
  fi

  # less colours
  if (( ! ${+LESS_TERMCAP_mb} )) export LESS_TERMCAP_mb=$'\E[1;31m'  # Begins blinking.
  if (( ! ${+LESS_TERMCAP_md} )) export LESS_TERMCAP_md=$'\E[1;31m'  # Begins bold.
  if (( ! ${+LESS_TERMCAP_me} )) export LESS_TERMCAP_me=$'\E[0m'     # Ends mode.
  if (( ! ${+LESS_TERMCAP_ue} )) export LESS_TERMCAP_ue=$'\E[0m'     # Ends underline.
  if (( ! ${+LESS_TERMCAP_us} )) export LESS_TERMCAP_us=$'\E[1;32m'  # Begins underline.
else
  # See https://no-color.org
  export NO_COLOR=1
fi


#
# ls GNU vs. BSD
#

if whence dircolors >/dev/null && ls --version &>/dev/null; then
  # GNU

  # ls aliases
  alias lx='ll -X' # long format, sort by extension
  if (( ${+NO_COLOR} )); then
    alias ls='ls --group-directories-first'
  else
    # ls colours
    if [[ -s ${HOME}/.dir_colors ]]; then
      eval "$(dircolors --sh ${HOME}/.dir_colors)"
    elif (( ! ${+LS_COLORS} )); then
      export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43'
    fi
    alias ls='ls --group-directories-first --color=auto'
  fi

  # Always wear a condom
  alias chmod='chmod --preserve-root -v'
  alias chown='chown --preserve-root -v'
else
  # BSD

  if (( ! ${+NO_COLOR} )); then
    # ls colours
    export CLICOLOR=1
    if (( ! ${+LSCOLORS} )) export LSCOLORS=ExfxcxdxbxGxDxabagacad
    # Stock OpenBSD ls does not support colors at all, but colorls does.
    if [[ ${OSTYPE} == openbsd* && ${+commands[colorls]} -ne 0 ]]; then
      alias ls=colorls
    fi
  fi
fi


function cg() {
  deno run --allow-run "$HOME/dotfiles/utils2/cgroup.ts" $@
}

function msr() {
  deno run -A "$HOME/dotfiles/utils2/msr.ts" $@
}

#
# ls Aliases
#

alias ll='ls -lh'         # long format and human-readable sizes
alias l='ll -A'           # long format, all files
alias lm="l | ${PAGER}"   # long format, all files, use pager
alias lk='ll -Sr'         # long format, largest file size last
alias lt='ll -tr'         # long format, newest modification time last
if (( ${+commands[lsd]} )); then
  alias ls=lsd
  alias lr='ll --tree'    # long format, recursive as a tree
  alias lx='ll -X'        # long format, sort by extension
else
  alias lr='ll -R'        # long format, recursive
  alias lc='lt -c'        # long format, newest status change (ctime) last, not supported by lsd
fi


# not aliasing rm -i, but if safe-rm is available, use condom.
# if safe-rmdir is available, the OS is suse which has its own terrible 'safe-rm' which is not what we want
if (( ${+commands[safe-rm]} && ! ${+commands[safe-rmdir]} )); then
  alias rm=safe-rm
fi

