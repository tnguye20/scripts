#!/bin/sh

echo "Start Installation"

if [ "$1" == "" ]; then
  dotBranch="ArchSimple"
else
  dotBranch=$1
fi

cd
sudo pacman -Syu --noconfirm
sudo pacman -S git --noconfirm
sudo pacman -S xclip --noconfirm

# ssh keygen
if [ -d ~/.ssh ]; then
  echo "SSH Keys exists"
else
  ssh-keygen -t rsa -b 4096 -C "tnguye20@uvm.edu" -q -N '' -f ~/.ssh/id_rsa
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  xclip -sel clip < ~/.ssh/id_rsa.pub
fi

# Google Chrome Install
if pacman -Qi google-chrome > /dev/null; then
  echo "Google Chrome is already installed"
else
  git clone https://aur.archlinux.org/google-chrome.git
  cd google-chrome
  makepkg -s
  sudo pacman -U --noconfirm google-chrome-*.pkg.tar.xz
  cd
  rm -rf google-chrome
fi

# rxvt-unicode-pixbuf Install
if pacman -Qi rxvt-unicode-pixbuf > /dev/null; then
  echo "rxvt-unicode-pixbuf is already install"
else
  sudo pacman -R rxvt-unicode --noconfirm
  git clone https://aur.archlinux.org/rxvt-unicode-pixbuf.git
  cd rxvt-unicode-pixbuf
  makepkg -si
  cd
  rm -rf rxvt-unicode-pixbuf
fi

# Tmux and oh-my-tmux
sudo pacman -s tmux --noconfirm
if [ -d ~/.tmux ]; then
  echo "oh-my-tmux is already installed"
else
  git clone https://github.com/gpakosz/.tmux.git
  ln -s -f .tmux/.tmux.conf
fi

# oh-my-zsh Install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# antigen install
if [ -d ~/antigen ]; then
  echo "antigen is already installed"
else
  git clone https://github.com/zsh-users/antigen.git ~/antigen
fi

# Config Files
if [ -d ~/.dotfiles ]; then
  echo ".dotfiles is already cloned"
  cd ~/.dotfiles
  git fetch
  git pull origin $dotBranch
else
  git clone --single-branch -b $dotBranch https://github.com/tnguye20/.dotfiles.git ~
  ln -s -f ~/.dotfiles/.vimrc
  ln -s -f ~/.dotfiles/.zshrc
  ln -s -f ~/.dotfiles/.tmux.conf.local
  ln -s -f ~/.dotfiles/.i3/config ~/.i3/
fi

# VIM plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

source ~/.zshrc
vim -c 'PlugUpdate' +qa
vim -c 'PlugInstall' +qa
source ~/.vimrc
