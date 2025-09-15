export PATH=$HOME/homebrew/$(uname -m)/bin:$PATH

# checking for interactive shell and exiting if so
[ -z "$PS1" ] && return
# run zsh if it exists
zsh --version &> /dev/null
if [ $? -eq 0 ]; then
  exec zsh --login
fi
