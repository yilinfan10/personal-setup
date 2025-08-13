#!/bin/bash
#
arch=$(uname -m)
echo "System is $arch"
if [ "$arch" = "aarch64" ]; then
  arch=arm64
fi
INSTALL_ROOT=/home/yilinf/local/$arch
TMP_ROOT=/tmp/setup
PATH=$PATH:$INSTALL_ROOT/bin

mkdir -p $TMP_ROOT
cd $TMP_ROOT

command_exists() {
  $1 --version &> /dev/null
}

if ! command_exists zsh; then
  if [ "$arch" = "arm64" ]; then
    echo "Building ncurses"
    wget https://ftpmirror.gnu.org/gnu/ncurses/ncurses-6.4.tar.gz
    tar xzf ncurses-6.4.tar.gz
    cd ncurses-6.4
    ./configure --prefix=$INSTALL_ROOT --with-shared --with-static CFLAGS='-fPIC'
    make && make install
    cd ..

    export CPPFLAGS="-I$INSTALL_ROOT/include"
    export LDFLAGS="-L$INSTALL_ROOT/lib"
    export LD_LIBRARY_PATH="$INSTALL_ROOT/lib:$LD_LIBRARY_PATH"
  fi

  echo "Building zsh"
  wget -P $TMP_ROOT/ https://sourceforge.net/projects/zsh/files/zsh/5.9/zsh-5.9.tar.xz/download
  tar xf $TMP_ROOT/download
  cd zsh-5.9 && ./Utils/preconfig
  ./configure --prefix=$INSTALL_ROOT
  make && make install
  cd ..

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

if ! command_exists fzf; then
  echo "Installing fzf"
  fzf_arch=$arch
  if [ "$arch" = "x86_64" ]; then
    fzf_arch="amd64"
  fi
  wget https://github.com/junegunn/fzf/releases/download/v0.65.0/fzf-0.65.0-linux_$fzf_arch.tar.gz
  tar xzf fzf-0.65.0-linux_$fzf_arch.tar.gz -C $INSTALL_ROOT/bin
fi

if ! command_exists nvim; then
  echo "Installing nvim"
  wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-$arch.tar.gz
  tar xzf nvim-linux-$arch.tar.gz --strip-components=1 -C $INSTALL_ROOT

  cd ~/.config
  git clone git@github-personal:yilinfan10/nvim-config.git nvim
  cd $TMP_ROOT
fi

if ! command_exists bat; then
  echo "Install bat"
  version=v0.25.0
  bat_arch=$arch
  if [ "$arch" = "arm64" ]; then
    bat_arch="aarch64"
  fi
  package_name=bat-${version}-${bat_arch}-unknown-linux-gnu
  wget https://github.com/sharkdp/bat/releases/download/${version}/${package_name}.tar.gz
  tar xzf ${package_name}.tar.gz
  cp ${package_name}/bat $INSTALL_ROOT/bin
fi

if ! command_exists git-lfs; then
  echo "Installing git lfs"
  lfs_arch=$arch
  if [ "$arch" = "x86_64" ]; then
    lfs_arch="amd64"
  fi
  wget https://github.com/git-lfs/git-lfs/releases/download/v3.4.1/git-lfs-linux-${lfs_arch}-v3.4.1.tar.gz
  tar -xvf git-lfs-linux-amd64-v3.4.1.tar.gz --strip-components=1 -C $INSTALL_ROOT/bin git-lfs-3.4.1/git-lfs
fi

if ! command_exists rg; then
  echo "Installing rg"

  version=14.1.1
  package_name=ripgrep-${version}-x86_64-unknown-linux-musl
  wget https://github.com/BurntSushi/ripgrep/releases/download/${version}/${package_name}.tar.gz
  tar -xvf ${package_name}.tar.gz --strip-components=1 -C $INSTALL_ROOT/bin ${package_name}/rg
fi

if ! command_exists npm; then
  echo "Installing nvm"
  mkdir -p $INSTALL_ROOT/nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | NVM_DIR=$INSTALL_ROOT/nvm bash

  source $NVM_DIR/nvm.sh

  echo "Installing npm"
  nvm install v24.4.0
fi

export PATH=$PATH:$HOME/.local/bin
if ! command_exists pipx; then
  pip install --user pipx
fi

export PIPX_BIN_DIR=$INSTALL_ROOT/bin

if ! command_exists trash-put; then
  echo "Installing trash-cli"
  pipx install trash-cli
fi
