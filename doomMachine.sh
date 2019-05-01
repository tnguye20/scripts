#!/bin/sh

echo "Start Installation"

user=$1

if [ "$2" == "" ]; then
  dotBranch="ArchSimple"
else
  dotBranch=$2
fi

cd
pacman -Syu --noconfirm
if pacman -Qi git > /dev/null; then
  echo "Git is already installed"
else
  pacman -S git --noconfirm
fi

if pacman -Qi xclip > /dev/null; then
  echo "xclip is already install"
else
  pacman -S xclip --noconfirm
fi

# ssh keygen
if [ -d /home/$user/.ssh ]; then
  echo "SSH Keys exists"
else
  ssh-keygen -t rsa -b 4096 -C "tnguye20@uvm.edu" -q -N '' -f /home/$user/.ssh/id_rsa
  eval "$(ssh-agent -s)"
  ssh-add /home/$user/.ssh/id_rsa
  xclip -sel clip < /home/$user/.ssh/id_rsa.pub
fi

# Google Chrome Install
if pacman -Qi google-chrome > /dev/null; then
  echo "Google Chrome is already installed"
else
  git clone https://aur.archlinux.org/google-chrome.git
  cd google-chrome
  makepkg -s
  pacman -U --noconfirm google-chrome-*.pkg.tar.xz
  cd
  rm -rf google-chrome
fi

# rxvt-unicode-pixbuf Install
if pacman -Qi rxvt-unicode-pixbuf > /dev/null; then
  echo "rxvt-unicode-pixbuf is already install"
else
  pacman -R rxvt-unicode --noconfirm
  git clone https://aur.archlinux.org/rxvt-unicode-pixbuf.git
  cd rxvt-unicode-pixbuf
  makepkg -si
  cd
  rm -rf rxvt-unicode-pixbuf
fi

# Tmux and oh-my-tmux
pacman -S tmux --noconfirm
if [ -d /home/$user/.tmux ]; then
  echo "oh-my-tmux is already installed"
else
  git clone https://github.com/gpakosz/.tmux.git
  ln -s -f .tmux/.tmux.conf
fi

# oh-my-zsh Install
if [ -d /home/$user/.oh-my-zsh ]; then
  echo "oh-my-zsh is already installed"
else
  su - $user -c " sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's:env zsh -l::g' | sed 's:chsh -s .*$::g')\" "
fi

# antigen install
if [ -f /home/$user/antigen.zsh ]; then
  echo "antigen is already installed"
else
  curl -L git.io/antigen > /home/$user/antigen.zsh
  source /home/$user/antigen.zsh
fi

# Config Files
if [ -d /home/$user/.dotfiles ]; then
  echo ".dotfiles is already cloned"
  cd /home/$user/.dotfiles
  git fetch
  git pull origin $dotBranch
else
  git clone --single-branch -b $dotBranch https://github.com/tnguye20/.dotfiles.git /home/$user/.dotfiles
  ln -s -f /home/$user/.dotfiles/.vimrc /home/$user/
  ln -s -f /home/$user/.dotfiles/.zshrc /gome/$user/
  ln -s -f /home/$user/.dotfiles/.tmux.conf.local /home/$user/
  ln -s -f /home/$user/.dotfiles/.i3/config /home/$user/.i3/
fi

# VIM plug
curl -fLo /home/$user/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

su - $user -c "source /home/$user/.zshrc"
su - $user -c "vim -c 'PlugUpdate' +qa"
su - $user -c "vim -c 'PlugInstall' +qa"
su - $user -c "source /home/$user/.vimrc"

chown -R $user:$user /home/$user/
