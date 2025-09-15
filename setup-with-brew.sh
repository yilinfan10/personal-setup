#!/bin/bash

command_exists() {
  $1 --version &> /dev/null
}

arch=$(uname -m)
echo "System is $arch"
BREW_HOME=/home/yilinf/homebrew/$arch

if ! command_exists brew; then
  echo "Installing brew"

  mkdir -p $BREW_HOME && curl -L https://github.com/Homebrew/brew/tarball/main | tar xz --strip-components 1 -C $BREW_HOME
  eval "$($BREW_HOME/bin/brew shellenv)"
  brew update --force --quiet
fi

# Define the list of packages you want to install in an array
declare -A packages
packages=(
    ["bat"]="bat"
    ["fzf"]="fzf"
    ["git-lfs"]="git-lfs"
    ["trash-cli"]="trash-put"
    ["ripgrep"]="rg"
    ["npm"]="npm"
    ["nvim"]="nvim"
    ["zsh"]="zsh"
    ["git"]="git"
)

# Loop through each package in the array
for package in "${!packages[@]}"; do
  command_name=${packages[$package]}
  if [ ! -f "$BREW_HOME/bin/$command_name" ]; then
    echo "📦 Installing $package..."
    brew install $package
  fi
done

echo "✅ All packages have been installed."
