#!/bin/sh

echo "Start Installation"

cd
sudo pacman -Syu --noconfirm
sudo pacman -S git --noconfirm
sudo pacman -S xclip --noconfirm

# ssh keygen
ssh-keygen -t rsa -b 4096 -C "tnguye20@uvm.edu" -q -N '' -f ~/.ssh/id_rsa
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
xclip -sel clip < ~/.ssh/id_rsa.pub

# Google Chrome Install
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -s
sudo pacman -U --noconfirm google-chrome-*.pkg.tar.xz
cd
rm -rf google-chrome

# rxvt-unicode-pixbuf Install
git clone https://aur.archlinux.org/rxvt-unicode-pixbuf.git
cd rxvt-unicode-pixbuf
makepkg -si
cd
rm -rf rxvt-unicode-pixbuf

# Tmux and oh-my-tmux
sudo pacman -s tmux
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf

# oh-my-zsh Install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# antigen install
git clone https://github.com/zsh-users/antigen.git ~/antigen

# VIM plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Config Files
git clone --single-branch -b ArchSimple git@github.com:tnguye20/.dotfiles.git ~
cp ~/.dotfiles/.vimrc ~
cp ~/.dotfiles/.zshrc ~
cp ~/.dotfiles/.tmux.conf.local ~
cp ~/.dotfiles/.i3/config ~/.i3/config

source ~/.zshrc
source ~/.vimrc
# vim -c 'PlugUpdate' +qa
# vim -c 'PlugInstall' +qa


