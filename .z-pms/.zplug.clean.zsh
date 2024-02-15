export ZPLUG_HOME=~/.zplug

if [[ -d $ZPLUG_HOME ]]; then
  mv $ZPLUG_HOME ~/.zplug-old
elif [[ $ZPM_REMOVE_OLD -eq 1 ]]; then
  rm -rf ~/.zplug
fi


