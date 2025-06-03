typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

if [[ ! -v LOAD_P10K ]]; then
  export LOAD_P10K='none'
fi

source "${ZINIT_HOME}/zinit.zsh"

function snippet() {
  zinit ice lucid wait
  zinit snippet "$1"
}

source $ZPM_ROOT/.z-headers.zsh

#ZSH_AUTOSUGGEST_MANUAL_REBIND=1

HISTFILE=~/.zhistory
HISTSIZE=1000000

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  bindkey -v
  bindkey -v '^?' backward-delete-char
  bindkey -v '^[[3~' delete-char
fi

zinit snippet "$HOME/.z-pms/.completion.zsh"
zinit for \
    atload"zicompinit; zicdreplay" \
    blockf \
    lucid \
    wait \
  zsh-users/zsh-completions

zi snippet OMZ::lib/history.zsh
#zi snippet OMZ::lib/completion.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
#zinit snippet OMZP::command-not-found

zmodload -F zsh/terminfo +p:terminfo
## Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
#for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
#for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
#for key ('k') bindkey -M vicmd ${key} history-substring-search-up
#for key ('j') bindkey -M vicmd ${key} history-substring-search-down
#unset key

zi ice lucid wait
zinit light zdharma-continuum/history-search-multi-word

zstyle :plugin:history-search-multi-word reset-prompt-protect 1

bindkey "^[R" history-search-multi-word

# Two regular plugins loaded without investigating.
zinit ice lucid wait atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
zinit ice lucid wait 1
zinit light zdharma-continuum/fast-syntax-highlighting
#zinit for \
#    atload"zicompinit; zicdreplay" \
#    blockf \
#    lucid \
#    wait \
#  zsh-users/zsh-completions
# zsh-users version
#zinit light zsh-users/zsh-syntax-highlighting

# Binary release in archive, from GitHub-releases page.
# After automatic unpacking it provides program "fzf".
#zi ice from"gh-r" as"program"
#zi light junegunn/fzf

#zi ice wait 1
#zi light tj/git-extras

zinit as'null' lucid wait'1' for \
  Fakerr/git-recall \
  davidosomething/git-my \
  iwata/git-now \
  paulirish/git-open \
  paulirish/git-recent \
    atload'export _MENU_THEME=legacy' \
  arzzen/git-quick-stats \
    make'install' \
  tj/git-extras \
    make'GITURL_NO_CGITURL=1' \
  zdharma-continuum/git-url
  #    sbin'git-url;git-guclone' \

zinit as'null' lucid wait'1' for \
  zimfw/git \
  zimfw/git-info \
  zimfw/utility

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^V' edit-command-line

# Snippet
#zinit snippet https://gist.githubusercontent.com/hightemp/5071909/raw/

# Load powerlevel10k theme
# zinit ice depth"1" # git clone depth
#zinit light romkatv/powerlevel10k

function __starship_transient() {
  return
  __starship__prompt() { PROMPT=$(starship prompt) }
  precmd_functions=(__starship__prompt)

  __starship__short_prompt() {
    if [[ $PROMPT != '%# ' ]]; then
        PROMPT=$(starship module character)
      zle .reset-prompt
    fi
  }

  zle-line-finish() { __starship__short_prompt }
  zle -N zle-line-finish

  trap '__starship__short_prompt; return 130' INT
}

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  # Load starship theme
  # line 1: `starship` binary as command, from github release
  # line 2: starship setup at clone(create init.zsh, completion)
  # line 3: pull behavior same as clone, source init.zsh
  zinit ice as"command" from"gh-r" \
            atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
            atload"__starship_transient" \
            atpull"%atclone" src"init.zsh"
  zinit light starship/starship
fi

autoload -Uz compinit
compinit

