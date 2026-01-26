export PATH=$HOME/local/$(uname -m)/bin:$PATH

# If not interactive, do nothing
[[ $- != *i* ]] && return

# Allow tools / scripts to opt out
[[ -n "${NO_AUTO_ZSH:-}" ]] && return

# Avoid recursion / weirdness
[[ -n "${ZSH_VERSION:-}" ]] && return
[[ -n "${BASH_SUBSHELL:-}" && "${BASH_SUBSHELL}" -gt 0 ]] && return

# run zsh if it exits
command -v zsh >/dev/null 2>&1 && exec zsh --login

export NVM_DIR="$HOME/local/$arch/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
