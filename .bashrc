export PATH=$HOME/local/$(uname -m)/bin:$PATH

# checking for interactive shell and exiting if so
[ -z "$PS1" ] && return
# run zsh if it exists
zsh --version &> /dev/null
if [ $? -eq 0 ]; then
  exec zsh --login
fi

export NVM_DIR="$HOME/local/$arch/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
