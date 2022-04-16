#!/bin/sh
echo "Start Installation for $USER"

# Force sudo without prompting password
sudo su - root -c  "echo \"$USER     ALL=(ALL) NOPASSWD:ALL \" >> /etc/sudoers"

cd /home/$USER

# Update packages and install random things that I like
sudo pacman -Syu --noconfirm
sudo pacman -R vim --noconfirm
sudo pacman -S \
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
  npm \
  nodejs \
  firefox \
  firefox-tridactyl \
  docker \
  cmus \
  mpd \
  zip \
  unzip \
  ncmpcpp \
  mpc \
  calcurse \
  flameshot \
  noto-fonts-emoji \
  freerdp \
  remmina \
  xtrlock \
  xcompmgr \
  neovim \
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
  polybar \
  youtube-dl \
  pavucontrol \
  plasma-browser-integration \
  pdftk \
  ctags \
  pavucontrol \
  pulseaudio-bluetooth \
  picom \
  rofi \
  atril \
  --noconfirm

# Get docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Get tridactyl theme
git clone https://github.com/bezmi/base16-tridactyl.git themes

# Init tridactyl
curl -fsSl https://raw.githubusercontent.com/tridactyl/tridactyl/master/native/install.sh -o /tmp/trinativeinstall.sh && bash /tmp/trinativeinstall.sh master

# Remove i3-gaps
sudo pacman -Rc i3-gaps --noconfirm

# Music Tool
mkdir -p $HOME/.config/mpd/
mkdir $HOME/.config/mpd/playlists

# Basic Git config
git config --global 'user.name' 'Thang Nguyen'
git config --global 'user.email' 'tnguye20@uvm.edu'

# Screenshots Directory
if [ ! -d $HOME/Pictures/Screenshots ]; then
  mkdir -p $HOME/Pictures/Screenshots
fi

# Rsync directory
mkdir -p $HOME/rsync
# Polybar directory
mkdir -p $HOME/.config/polybar

# Clone packages and install them all
mkdir -p $HOME/packages
cd $HOME/packages
mkdir -p lfs
cd lfs
curl -L "https://github.com/git-lfs/git-lfs/releases/download/v2.7.2/git-lfs-linux-amd64-v2.7.2.tar.gz" > lfs.tar.gz
tar -xzvf lfs.tar.gz
sudo sh install.sh
git lfs install --force
cd $HOME/packages
rm -rf lfs

git clone https://aur.archlinux.org/ttf-iosevka.git
git clone https://aur.archlinux.org/ttf-patrick-hand-full.git
git clone https://aur.archlinux.org/fpp-git.git
git clone https://aur.archlinux.org/slack-desktop.git
# git clone https://aur.archlinux.org/rxvt-unicode-pixbuf.git
git clone https://aur.archlinux.org/visual-studio-code-bin.git
git clone https://aur.archlinux.org/postman-bin.git
git clone https://aur.archlinux.org/zsa-wally.git
git clone https://aur.archlinux.org/drawio-desktop.git
git clone https://aur.archlinux.org/alacritty-themes.git
git clone https://aur.archlinux.org/i3-gaps-rounded-git.git
git clone https://aur.archlinux.org/ifuse.git
git clone https://aur.archlinux.org/starship-bin.git
git clone https://aur.archlinux.org/nerd-fonts-complete.git
git clone  https://aur.archlinux.org/ttf-patrick-hand-full.git
git clone https://aur.archlinux.org/neovide-git.git

ls | xargs -I {} sh -c "cd {}; makepkg -sicf --noconfirm; cd -"

# Clone packages that does not require makepkg
## Music control for polybar
pip3 install pydbus
git clone https://github.com/tnguye20/polybar-browsermediacontrol.git

# Reset Fonts
sudo fc-cache

# Reinstall i3exit
sudo pacman -S i3exit --noconfirm

cd $HOME/

# Get BumbleBee Status for i3Status
[ ! -d $HOME/bumblebee-status ] && git clone https://github.com/tobi-wan-kenobi/bumblebee-status.git $HOME/bumblebee-status

# Get nvm in case I'm still a node.js developer
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# ssh keygen
if [ -d $HOME/.ssh ]; then
  echo "SSH Keys exists"
else
  ssh-keygen -t rsa -b 4096 -C "tnguye20@uvm.edu" -q -N '' -f $HOME/.ssh/id_rsa
  eval "$(ssh-agent -s)"
  ssh-add $HOME/.ssh/id_rsa
  xclip -sel clip < $HOME/.ssh/id_rsa.pub
fi

# oh-my-tmux
if [ -d $HOME/.tmux ]; then
  echo "oh-my-tmux is already installed"
else
  git clone https://github.com/gpakosz/.tmux.git
  ln -s -f .tmux/.tmux.conf
fi

# oh-my-zsh
if [ -d $HOME/.oh-my-zsh ]; then
  echo "oh-my-zsh is already installed"
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# antigen install
if [ -f $HOME/antigen.zsh ]; then
  echo "antigen is already installed"
else
  curl -L git.io/antigen > $HOME/antigen.zsh
fi

# Install st - the suckless terminal for VIM colors mostly
git clone https://github.com/tnguye20/st.git $HOME/st
cd $HOME/st
make
sudo make install
cd

# Repo directory
mkdir -p $HOME/repo

# Config Files and Scripts
if [ -d $HOME/.dotfiles ]; then
  echo ".dotfiles is already cloned"
  cd $HOME/.dotfiles
  git fetch
  git pull origin $dotBranch
else
  git lfs install --force
  git clone https://github.com/tnguye20/.dotfiles.git $HOME/.dotfiles
  git clone https://github.com/tnguye20/scripts.git $HOME/scripts
  cd $HOME/.dotfiles
  git lfs install
  git lfs pull
  cd
fi
ln -s -f $HOME/.dotfiles/.vimrc $HOME/
ln -s -f $HOME/.dotfiles/.zshrc $HOME/
ln -s -f $HOME/.dotfiles/.tridactylrc $HOME/
ln -s -f $HOME/.dotfiles/.tmux.conf.local $HOME/
ln -s -f $HOME/.dotfiles/.i3/config $HOME/.i3/
ln -s -f $HOME/.dotfiles/.config/mpd/mpd.conf $HOME/.config/mpd/
ln -s -f $HOME/.dotfiles/.config/alacritty/ $HOME/.config
ln -s -f $HOME/.dotfiles/.config/ranger/rc.conf $HOME/.config/ranger/
ln -s -f $HOME/.dotfiles/.config/neofetch/config.conf $HOME/.config/neofetch/
ln -s -f $HOME/.dotfiles/.calcurse/conf $HOME/.calcurse/
ln -s -f $HOME/.dotfiles/.Xresources $HOME/.Xresources
ln -s -f $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
ln -s -f $HOME/.dotfiles/.profile $HOME/.profile
ln -s -f $HOME/.dotfiles/.cool-retro-term $HOME/cool-retro-term
ln -s -f $HOME/.dotfiles/.config/polybar/config $HOME/.config/polybar/
ln -s -f $HOME/.dotfiles/.config/nvim/init.vim $HOME/.config/nvim/
ln -s -f $HOME/.dotfiles/.config/picom.conf $HOME/.config/
ln -s -f $HOME/.dotfiles/.config/rofi $HOME/.config/rofi
ln -s -f $HOME/.dotfiles/.vimrc $HOME/.ideavimrc

cd $HOME/.dotfiles/ && git clean -f

# Copy first lockscreen to position
# sudo cp $HOME/.dotfiles/.wallpaper/mr_robot.jpg /usr/share/backgrounds/lockscreen.png

# rofi setup
cd $HOME/packages
git clone https://github.com/lr-tech/rofi-themes-collection.git
mkdir -p $HOME/.local/share/rofi/themes
cp rofi-themes-collection/themes/* $HOME/.local/share/rofi/themes
cd

# VIM plug
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

source $HOME/.zshrc

sed -i 's/^colorscheme/\" colorscheme/g' $HOME/.vimrc
sed -i 's/\(^Plug.*coc\)/\"\1/g' $HOME/.vimrc
vim +'PlugUpdate' +qa
vim +'PlugInstall' +qa
vim +'source %' +qa

# Install pywal
sudo pacman -S python-pip --noconfirm
sudo pacman -S python-pywal --noconfirm

# Set Default Wallpaper
# feh --bg-scale $HOME/.dotfiles/.wallpaper/pink_mountain.jpg
sh $HOME/scripts/randomWallpaper

# Set ranger config
ranger --copy-config=all

# Set default shell to zsh
sudo usermod --shell /bin/zsh $USER

# Restart i3
i3-msg reload

# Update Permission
chown -R $USER:$USER $HOME/

#rsync -avcXL --delete --progress tnguye20@w3.uvm.edu:~/rsync/ ~/rsync/

# Kick you into ZSH
zsh

# Boot into starship
eval "$(starship init zsh)"

[ -f "$HOME/doomMachine.sh" ] && rm -rf "$HOME/doomMachine.sh"
