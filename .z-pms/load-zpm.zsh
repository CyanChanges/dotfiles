# zpm
if [[ ! -f ~/.zpm/zpm.zsh ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm ~/.zpm
fi
source ~/.zpm/zpm.zsh

source ${ZPMS_DIR:-$ZPM_ROOT/.z-pms/}/zpm.zsh

