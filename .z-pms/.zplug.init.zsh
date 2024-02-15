export ZPLUG_HOME=~/.zplug


if [[ -d "$ZPLUG_HOME.old" ]]; then
  mv $ZPLUG_HOME.old $ZPLUG_HOME
elif [[ ! -d $ZPLUG_HOME ]]; then
  git clone --depth 1 https://github.com/zplug/zplug $ZPLUG_HOME
fi

