zpm load @omz

zpm load                \
  @omz/lib/compfix      \
  @omz/lib/completion   \
  @omz/lib/directories  \
  @omz/lib/functions    \
  @omz/lib/git          \
  @omz/lib/grep         \
  @omz/lib/history      \
  @omz/lib/key-bindings \
  @omz/lib/misc         \
  @omz/lib/spectrum     \
  @omz/lib/theme-and-appearance

zpm load                \
  @omz/virtualenv       \
  @omz/git              \

zpm load zsh-users/zsh-syntax-highlighting

if [[ ! -d ~/powerlevel10k ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
fi

#zpm load @omz/theme/powerlevel10k/powerlevel10k

source ~/powerlevel10k/powerlevel10k.zsh-theme

#rm /tmp/zsh-1000 -rf > /dev/null
#zpm load @omz/theme/robbyrussell


