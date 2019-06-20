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

# Update packages and install random things that I like
pacman -Syu --noconfirm
sudo pacman -S bat --noconfirm
sudo pacman -S terminology --noconfirm
sudo pacman -S gvim --noconfirm
sudo pacman -S copyq --noconfirm
sudo pacman -S figlet --noconfirm
sudo pacman -S xorg-server --noconfirm
sudo pacman -S cmatrix --noconfirm


# Music Tool
sudo pacman -S cmus --noconfirm
sudo pacman -S mpd ncmpcpp mpc --noconfirm
mkdir -p ~/.config/mpd/
mkdir ~/.config/mpd/playlists

# Calendar Tool
sudo pacman -S calcurse --noconfirm

#Screenshot Tool
sudo pacman -S flameshot --noconfirm
if [ ! -d ~/Pictures/Screenshots ]; then
  mkdir -p ~/Pictures/Screenshots
fi

# Install Git, Git lfs and basic config vars
if pacman -Qi git > /dev/null; then
  echo "Git is already installed"
else
  sudo pacman -S git --noconfirm
  git config --global 'user.name' 'Thang Nguyen'
  git config --global 'user.email' 'tnguye20@uvm.edu'

  mdkir -p ~/lfs
  cd lfs
  curl -L "https://github.com/git-lfs/git-lfs/releases/download/v2.7.2/git-lfs-linux-amd64-v2.7.2.tar.gz" > lfs.tar.gz
  tar -xzvf lfs.tar.gz
  sh ./install.sh
  git lfs install
  cd ~
  rm -rf lfs
fi

# Get BumbleBee Status for i3Status
[ ! -d ~/bumblebee-status ] && git clone https://github.com/tobi-wan-kenobi/bumblebee-status.git /home/$user/bumblebee-status

# Install meld and diff/merge tool
if pacman -Qi meld > /dev/null; then
  echo "Meld is already installed"
else
  sudo pacman -S meld --noconfirm
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

# fpp Install
if pacman -Qi fpp > /dev/null; then
  echo "fpp is already installed"
else
  git clone https://aur.archlinux.org/fpp-git.git /home/$user/fpp-git
  cd /home/$user/fpp-git
  makepkg -si
  cd /home/$user/
  rm -rf /home/$user/fpp-git
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
  git lfs install
fi
ln -s -f /home/$user/.dotfiles/.vimrc /home/$user/
ln -s -f /home/$user/.dotfiles/.zshrc /home/$user/
ln -s -f /home/$user/.dotfiles/.tmux.conf.local /home/$user/
ln -s -f /home/$user/.dotfiles/.i3/config /home/$user/.i3/
ln -s -f /home/$user/.dotfiles/.config/mpd/mpd.conf /home/$user/.config/mpd/
ln -s -f /home/$user/.dotfiles/.config/ranger/rc.conf ~/.config/ranger/
ln -s -f /home/$user/.dotfiles/.calcurse/conf ~/.calcurse/
ln -s -f /home/$user/.dotfiles/.Xresources ~/.Xresources
ln -s -f /home/$user/.dotfiles/.gitconfig ~/.gitconfig

# VIM plug
curl -fLo /home/$user/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Ctags
git clone https://aur.archlinux.org/universal-ctags-git.git
cd universal-ctags-git
makepkg -si
cd
rm universal-ctags-git

source /home/$user/.zshrc
vim +'PlugUpdate' +qa
vim +'PlugInstall' +qa
source /home/$user/.vimrc

# Install pywal
sudo pacman -S python-pip --noconfirm
sudo pip3 install pywal

# Set Default Wallpaper
feh --bg-scale /home/$user/.dotfiles/.wallpaper/pink_mountain.jpg

# Set ranger config
ranger --copy-config=all

# Restart i3
i3-msg reload

# Update Permission
chown -R $user:$user /home/$user/
