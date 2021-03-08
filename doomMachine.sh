#!/bin/sh
echo "Start Installation for $USER"

# Force sudo without prompting password
sudo su - root -c  "echo \"$USER     ALL=(ALL) NOPASSWD:ALL \" >> /etc/sudoers"

cd /home/$USER

# Update packages and install random things that I like
sudo pacman -Syu --noconfirm
sudo pacman -S \
  base-devel \
  make \
  zsh \
  sudo \
  ranger \
  bat \
  terminology \
  gvim \
  copyq \
  figlet \
  xorg-server \
  cmatrix \
  neofetch \
  gifsicle \
  cool-retro-term \
  lxappearance \
  ripgrep \
  poppler \
  npm \
  nodejs \
  firefox \
  firefox-tridactyl \
  docker \
  cmus \
  mpd \
  ncmpcpp \
  mpc \
  calcurse \
  flameshot \
  noto-fonts-emoji \
  freerdp \
  remmina \
  xtrlock \
  xcompmgr \
  synergy \
  simplescreenrecorder \
  ttf-fira-code \
  alacritty \
  meld \
  xclip \
  feh \
  git \
  discord \
  dbeaver \
  tmux \
  polybar
  plasma-browser-integration \
  --noconfirm

# Init tridactyl
curl -fsSl https://raw.githubusercontent.com/tridactyl/tridactyl/master/native/install.sh -o /tmp/trinativeinstall.sh && bash /tmp/trinativeinstall.sh master

# Remove i3-gaps
sudo pacman -Rc i3-gaps

# Music Tool
mkdir -p /home/$USER/.config/mpd/
mkdir /home/$USER/.config/mpd/playlists

# Basic Git config
git config --global 'user.name' 'Thang Nguyen'
git config --global 'user.email' 'tnguye20@uvm.edu'

# Screenshots Directory
if [ ! -d /home/$USER/Pictures/Screenshots ]; then
  mkdir -p /home/$USER/Pictures/Screenshots
fi

# Rsync directory
mkdir -p /home/$USER/rsync
# Polybar directory
mkdir -p /home/$USER/.config/polybar

# Clone packages and install them all
mkdir -p /home/$USER/packages
cd /home/$USER/packages
mkdir -p lfs
cd lfs
curl -L "https://github.com/git-lfs/git-lfs/releases/download/v2.7.2/git-lfs-linux-amd64-v2.7.2.tar.gz" > lfs.tar.gz
tar -xzvf lfs.tar.gz
sudo sh install.sh
git lfs install --force
cd /home/$USER/packages
rm -rf lfs

git clone https://aur.archlinux.org/ttf-iosevka.git
git clone https://aur.archlinux.org/forticlientsslvpn.git
git clone https://aur.archlinux.org/fpp-git.git
git clone https://aur.archlinux.org/slack-desktop.git
# git clone https://aur.archlinux.org/rxvt-unicode-pixbuf.git
git clone https://aur.archlinux.org/postman-bin.git
git clone https://aur.archlinux.org/zsa-wally.git
git clone https://aur.archlinux.org/drawio-desktop.git
git clone https://aur.archlinux.org/alacritty-themes.git
git clone https://aur.archlinux.org/i3-gaps-rounded-git.git
git clone https://aur.archlinux.org/ifuse.git
git clone https://aur.archlinux.org/starship-bin.git
ls | xargs -I {} sh -c "cd {}; makepkg -sicf --noconfirm; cd -"

# Clone packages that does not require makepkg
## Music control for polybar
pip3 install pydbus
git clone https://github.com/tnguye20/polybar-browsermediacontrol.git

# Reset Fonts
sudo fc-cache

# Reinstall i3exit
sudo pacman -S i3exit --noconfirm

cd /home/$USER/

# Get BumbleBee Status for i3Status
[ ! -d /home/$USER/bumblebee-status ] && git clone https://github.com/tobi-wan-kenobi/bumblebee-status.git /home/$USER/bumblebee-status

# ssh keygen
if [ -d /home/$USER/.ssh ]; then
  echo "SSH Keys exists"
else
  ssh-keygen -t rsa -b 4096 -C "tnguye20@uvm.edu" -q -N '' -f /home/$USER/.ssh/id_rsa
  eval "$(ssh-agent -s)"
  ssh-add /home/$USER/.ssh/id_rsa
  xclip -sel clip < /home/$USER/.ssh/id_rsa.pub
fi

# oh-my-tmux
if [ -d /home/$USER/.tmux ]; then
  echo "oh-my-tmux is already installed"
else
  git clone https://github.com/gpakosz/.tmux.git
  ln -s -f .tmux/.tmux.conf
fi

# oh-my-zsh
if [ -d /home/$USER/.oh-my-zsh ]; then
  echo "oh-my-zsh is already installed"
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# antigen install
if [ -f /home/$USER/antigen.zsh ]; then
  echo "antigen is already installed"
else
  curl -L git.io/antigen > /home/$USER/antigen.zsh
fi

# Install st - the suckless terminal for VIM colors mostly
git clone https://github.com/tnguye20/st.git /home/$USER/st
cd /home/$USER/st
make
sudo make install
cd

# Config Files and Scripts
if [ -d /home/$USER/.dotfiles ]; then
  echo ".dotfiles is already cloned"
  cd /home/$USER/.dotfiles
  git fetch
  git pull origin $dotBranch
else
  git lfs install --force
  git clone https://github.com/tnguye20/.dotfiles.git /home/$USER/.dotfiles
  git clone https://github.com/tnguye20/scripts.git /home/$USER/scripts
  cd /home/$USER/.dotfiles
  git lfs install
  git lfs pull
  cd
fi
ln -s -f /home/$USER/.dotfiles/.vimrc /home/$USER/
ln -s -f /home/$USER/.dotfiles/.zshrc /home/$USER/
ln -s -f /home/$USER/.dotfiles/.tridactylrc /home/$USER/
ln -s -f /home/$USER/.dotfiles/.tmux.conf.local /home/$USER/
ln -s -f /home/$USER/.dotfiles/.i3/config /home/$USER/.i3/
ln -s -f /home/$USER/.dotfiles/.config/mpd/mpd.conf /home/$USER/.config/mpd/
ln -s -f /home/$USER/.dotfiles/.config/alacritty/ /home/$USER/.config
ln -s -f /home/$USER/.dotfiles/.config/ranger/rc.conf /home/$USER/.config/ranger/
ln -s -f /home/$USER/.dotfiles/.config/neofetch/config.conf /home/$USER/.config/neofetch/
ln -s -f /home/$USER/.dotfiles/.calcurse/conf /home/$USER/.calcurse/
ln -s -f /home/$USER/.dotfiles/.Xresources /home/$USER/.Xresources
ln -s -f /home/$USER/.dotfiles/.gitconfig /home/$USER/.gitconfig
ln -s -f /home/$USER/.dotfiles/.profile /home/$USER/.profile
ln -s -f /home/$USER/.dotfiles/.cool-retro-term /home/$USER/cool-retro-term
ln -s -f /home/$USER/.dotfiles/.config/polybar/config /home/$USER/.config/polybar/

# VIM plug
curl -fLo /home/$USER/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Ctags
git clone https://aur.archlinux.org/universal-ctags-git.git
cd universal-ctags-git
makepkg -sicf --noconfirm
cd
rm universal-ctags-git

source /home/$USER/.zshrc

sed -i 's/^colorscheme/\" colorscheme/g' /home/$USER/.vimrc
sed -i 's/\(^Plug.*coc\)/\"\1/g' /home/$USER/.vimrc
vim +'PlugUpdate' +qa
vim +'PlugInstall' +qa
vim +'source %' +qa

# Install pywal
sudo pacman -S python-pip --noconfirm
sudo pacman -S python-pywal --noconfirm

# Set Default Wallpaper
# feh --bg-scale /home/$USER/.dotfiles/.wallpaper/pink_mountain.jpg
sh /home/$USER/scripts/randomWallpaper

# Set ranger config
ranger --copy-config=all

# Set default shell to zsh
sudo usermod --shell /bin/zsh $USER

# Restart i3
i3-msg reload

# Update Permission
chown -R $USER:$USER /home/$USER/

#rsync -avcXL --delete --progress tnguye20@w3.uvm.edu:~/rsync/ ~/rsync/

# Kick you into ZSH
zsh

# Boot into starship
eval "$(starship init zsh)"

[ -f "/home/$USER/doomMachine.sh" ] && rm -rf "/home/$USER/doomMachine.sh"
