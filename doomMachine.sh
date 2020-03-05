#!/bin/sh


if [ $# -ne 1 ]; then
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

sudo pacman -Syu --noconfirm
# Update packages and install random things that I like
sudo pacman -S bat --noconfirm
sudo pacman -S terminology --noconfirm
sudo pacman -S gvim --noconfirm
sudo pacman -S copyq --noconfirm
sudo pacman -S figlet --noconfirm
sudo pacman -S xorg-server --noconfirm
sudo pacman -S cmatrix --noconfirm
sudo pacman -S neofetch --noconfirm
sudo pacman -S gifsicle --noconfirm
sudo pacman -S cool-retro-term --noconfirm
sudo pacman -S lxappearance --noconfirm
sudo pacman -S ripgrep --noconfirm
sudo pacman -S poppler --noconfirm
sudo pacman -S npm --noconfirm
sudo pacman -S nodejs --noconfirm
sudo pacman -S firefox --noconfirm
sudo pacman -S firefox-tridactyl --noconfirm
sudo pacman -S docker --noconfirm
sudo pacman -S cmus --noconfirm
sudo pacman -S mpd ncmpcpp mpc --noconfirm
sudo pacman -S calcurse --noconfirm
sudo pacman -S flameshot --noconfirm
if [ ! -d /home/$user/Pictures/Screenshots ]; then
  mkdir -p /home/$user/Pictures/Screenshots
fi

mkdir -p /home/$user/packages

# Init tridactyl
curl -fsSl https://raw.githubusercontent.com/tridactyl/tridactyl/master/native/install.sh -o /tmp/trinativeinstall.sh && bash /tmp/trinativeinstall.sh master

# Iosevka Font since Edwin is such a hacker
cd /home/$user/packages
git clone https://aur.archlinux.org/ttf-iosevka.git
cd ttf-iosevka
makepkg -si --noconfirm
sudo fc-cache

# Forticlient for work
cd /home/$user/packages
git clone https://aur.archlinux.org/forticlientsslvpn.git
cd forticlientsslvpn
makepkg -si --noconfirm
rm -rf forticlientsslvpn

# Music Tool
mkdir -p /home/$user/.config/mpd/
mkdir /home/$user/.config/mpd/playlists

# Install Git, Git lfs and basic config vars
if pacman -Qi git > /dev/null; then
  echo "Git is already installed"
else
  sudo pacman -S git --noconfirm
fi
git config --global 'user.name' 'Thang Nguyen'
git config --global 'user.email' 'tnguye20@uvm.edu'

cd /home/$user/packages
mkdir -p lfs
cd lfs
curl -L "https://github.com/git-lfs/git-lfs/releases/download/v2.7.2/git-lfs-linux-amd64-v2.7.2.tar.gz" > lfs.tar.gz
tar -xzvf lfs.tar.gz
sh install.sh
git lfs install
cd /home/$user
rm -rf lfs

# Get BumbleBee Status for i3Status
[ ! -d /home/$user/bumblebee-status ] && git clone https://github.com/tobi-wan-kenobi/bumblebee-status.git /home/$user/bumblebee-status

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

# fpp Install
if pacman -Qi fpp > /dev/null; then
  echo "fpp is already installed"
else
  cd /home/$user/packages
  git clone https://aur.archlinux.org/fpp-git.git /home/$user/fpp-git
  cd fpp-git
  makepkg -si --noconfirm
  cd /home/$user/
  rm -rf /home/$user/fpp-git
fi

# Slack Install
if pacman -Qi slack-desktop > /dev/null; then
  echo "Slack is already installed"
else
  cd /home/$user/packages
  git clone https://aur.archlinux.org/slack-desktop.git /home/$user/slack-desktop
  cd slack-desktop
  makepkg -si --noconfirm
  cd /home/$user/
  rm -rf /home/$user/slack-desktop
fi

# rxvt-unicode-pixbuf Install
if pacman -Qi rxvt-unicode-pixbuf > /dev/null; then
  echo "rxvt-unicode-pixbuf is already install"
else
  cd /home/$user/packages
  git clone https://aur.archlinux.org/rxvt-unicode-pixbuf.git /home/$user/rxvt-unicode-pixbuf
  cd rxvt-unicode-pixbuf
  makepkg -si --noconfirm
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
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# antigen install
if [ -f /home/$user/antigen.zsh ]; then
  echo "antigen is already installed"
else
  curl -L git.io/antigen > /home/$user/antigen.zsh
fi

# Install st - the suckless terminal for VIM colors mostly
git clone https://github.com/tnguye20/st.git /home/$user/st
cd /home/$user/st
make
sudo make install
cd

# Config Files and Scripts
if [ -d /home/$user/.dotfiles ]; then
  echo ".dotfiles is already cloned"
  cd /home/$user/.dotfiles
  git fetch
  git pull origin $dotBranch
else
  git lfs install
  git clone https://github.com/tnguye20/.dotfiles.git /home/$user/.dotfiles
  git clone https://github.com/tnguye20/scripts.git /home/$user/scripts
  cd /home/$user/.dotfiles
  git lfs install
  git lfs pull
  cd
fi
ln -s -f /home/$user/.dotfiles/.vimrc /home/$user/
ln -s -f /home/$user/.dotfiles/.zshrc /home/$user/
ln -s -f /home/$user/.dotfiles/.tridactylrc /home/$user/
ln -s -f /home/$user/.dotfiles/.tmux.conf.local /home/$user/
ln -s -f /home/$user/.dotfiles/.i3/config /home/$user/.i3/
ln -s -f /home/$user/.dotfiles/.config/mpd/mpd.conf /home/$user/.config/mpd/
ln -s -f /home/$user/.dotfiles/.config/ranger/rc.conf /home/$user/.config/ranger/
ln -s -f /home/$user/.dotfiles/.config/neofetch/config.conf /home/$user/.config/neofetch/
ln -s -f /home/$user/.dotfiles/.calcurse/conf /home/$user/.calcurse/
ln -s -f /home/$user/.dotfiles/.Xresources /home/$user/.Xresources
ln -s -f /home/$user/.dotfiles/.gitconfig /home/$user/.gitconfig
ln -s -f /home/$user/.dotfiles/.profile /home/$user/.profile
ln -s -f /home/$user/.dotfiles/.cool-retro-term /home/$user/cool-retro-term

# VIM plug
curl -fLo /home/$user/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Ctags
git clone https://aur.archlinux.org/universal-ctags-git.git
cd universal-ctags-git
makepkg -si --noconfirm
cd
rm universal-ctags-git

source /home/$user/.zshrc
vim +'PlugUpdate' +qa
vim +'PlugInstall' +qa
source /home/$user/.vimrc

# Install pywal
sudo pacman -S python-pip --noconfirm
sudo pacman -S python-pywal --noconfirm

# Set Default Wallpaper
# feh --bg-scale /home/$user/.dotfiles/.wallpaper/pink_mountain.jpg
sh /home/$user/scripts/randomWallpaper

# Set ranger config
ranger --copy-config=all

# Set default shell to zsh
sudo usermod --shell /bin/zsh $user

# Restart i3
i3-msg reload

# Update Permission
chown -R $user:$user /home/$user/

# Kick you into ZSH
zsh

if [ -f "/home/$user/doomMachine.sh" ];then
  rm -rf "/home/$user/doomMachine.sh"
fi
