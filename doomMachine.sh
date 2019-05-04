#!/bin/sh


if [ "$1" == "" ]; then
  echo "Pleass enter username!!!"
  exit 1
fi

echo "Start Installation"

user=$1

if [ "$2" == "" ]; then
  dotBranch="master"
else
  dotBranch=$2
fi

# Force sudo without prompting password
sudo su - root -c  "echo \"$user     ALL=(ALL) NOPASSWD:ALL \" >> /etc/sudoers "

cd /home/$user

# Update packages
pacman -Syu --noconfirm
sudo pacman -S bat --noconfirm
sudo pacman -S terminology --noconfirm

# Install Git and basic config vars
if pacman -Qi git > /dev/null; then
  echo "Git is already installed"
else
  sudo pacman -S git --noconfirm
  git config --global 'user.name' 'Thang Nguyen'
  git config --global 'user.email' 'tnguye20@uvm.edu'
fi

# Install meld and diff/merge tool
if pacman -Qi meld > /dev/null; then
  echo "Meld is already installed"
else
  sudo pacman -S meld --noconfirm
  git config --global diff.tool meld
  git config --global difftool.meld.path '/usr/bin/meld'
  git config --global difftool.prompt false
  git config --global difftool.meld.cmd 'meld \"$LOCAL\" \"$REMOTE\"'

  git config --global merge.tool meld
  git config --global mergetool.meld.path '/usr/bin/meld'
  git config --global mergetool.prompt false
  git config --global mergetool.meld.cmd 'meld \"$LOCAL\" \"$BASE\" \"$REMOTE\" --output \"$MERGED\"'
fi

if pacman -Qi xclip > /dev/null; then
  echo "xclip is already install"
else
  sudo pacman -S xclip --noconfirm
fi

if pacman -Qi feh > /dev/null; then
  echo "feh is already install"
else
  sudo pacman -S feh --noconfirm
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
  git clone https://aur.archlinux.org/google-chrome.git /home/$user/google-chrome
  cd /home/$user/google-chrome
  makepkg -si
  cd /home/$user/
  rm -rf /home/$user/google-chrome
fi

# rxvt-unicode-pixbuf Install
if pacman -Qi rxvt-unicode-pixbuf > /dev/null; then
  echo "rxvt-unicode-pixbuf is already install"
else
  git clone https://aur.archlinux.org/rxvt-unicode-pixbuf.git /home/$user/rxvt-unicode-pixbuf
  cd /home/$user/rxvt-unicode-pixbuf
  makepkg -si
  cd /home/$user/
  rm -rf /home/$user/rxvt-unicode-pixbuf
fi

# Tmux and oh-my-tmux
if pacman -Qi tmux> /dev/null; then
  echo "tmux is already install"
else
  sudo pacman -S tmux --noconfirm
fi
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
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's:env zsh -l::g' | sed 's:chsh -s .*$::g')"
fi

# antigen install
if [ -f /home/$user/antigen.zsh ]; then
  echo "antigen is already installed"
else
  curl -L git.io/antigen > /home/$user/antigen.zsh
fi

# Config Files
if [ -d /home/$user/.dotfiles ]; then
  echo ".dotfiles is already cloned"
  cd /home/$user/.dotfiles
  git fetch
  git pull origin $dotBranch
else
  git clone --single-branch -b $dotBranch https://github.com/tnguye20/.dotfiles.git /home/$user/.dotfiles
  cd /home/$user/.dotfiles/
  ln -s -f /home/$user/.dotfiles/.vimrc /home/$user/
  ln -s -f /home/$user/.dotfiles/.zshrc /home/$user/
  ln -s -f /home/$user/.dotfiles/.tmux.conf.local /home/$user/
  ln -s -f /home/$user/.dotfiles/.i3/config /home/$user/.i3/
fi

# VIM plug
curl -fLo /home/$user/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

source /home/$user/.zshrc
vim +'PlugUpdate' +qa
vim +'PlugInstall' +qa
source /home/$user/.vimrc

# Set Default Wallpaper
feh --bg-scale /home/$user/.dotfiles/.wallpaper/mr_robot.jpg

# Set ranger config
ranger --copy-config=all

# Restart i3
i3-msg reload

# Update Permission
chown -R $user:$user /home/$user/
