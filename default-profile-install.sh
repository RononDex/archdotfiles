#!/bin/sh

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

sudo pacman -Syy
sudo pacman -Syu --noconfirm
sudo pacman -Sy wget git --noconfirm --needed

echo "Updating file permissions ..."
chmod +x ~/.xinitrc
chmod +x ~/.profile/xprofile
chmod +x ~/.profile/bashprofile
chmod +x ~/.config/i3/config
chmod +x ~/.config/polybar/config
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/polybar/network-traffic.sh
chmod +x ~/.config/xfce4/terminal/terminalrc
chmod +x ~/.i3/scripts/launch-picom.sh
chmod +x ~/.i3/scripts/launch-autostart.sh
chmod +x ~/.i3/scripts/set-background.sh
chmod +x ~/.scripts/updateLoginBackground.sh

echo "Changing default shell to zsh"
if [[ "$SHELL" != "/bin/zsh" ]]; then
    chsh -s /bin/zsh
fi

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
zplug update

echo "Configuring pacman ..."
sudo cp defaults/pacman.conf /etc/pacman.conf
sudo cp defaults/mirrorlist /etc/pacman.d/mirrorlist
sudo chmod 744 /etc/pacman.conf
sudo chmod 744 /etc/pacman.d/mirrorlist

rm ~/pacman.conf
rm ~/mirrorlist

echo "Installing stuff..."
sudo pacman -Sy powerline-fonts gcc boost ffmpeg make cmake otf-fira-code otf-fira-mono otf-fira-sans ttf-fira-code ttf-fira-mono ttf-fira-sans bash-completion zsh zsh-completions git --noconfirm --needed
sudo pacman -Sy bash-completion networkmanager gnome-keyring network-manager-applet xorg xorg-xinit lightdm light-locker firefox adobe-source-code-pro-fonts neofetch --noconfirm --needed
sudo pacman -Sy lightdm-webkit-theme-litarvan feh xfce4-terminal picom alsa pulseaudio pulseaudio-jack pulseaudio-alsa pavucontrol arc-gtk-theme arc-icon-theme nautilus --noconfirm --needed
sudo pacman -Sy java-runtime-common jre-openjdk ntfs-3g autofs --noconfirm --needed
sudo pacman -Sy vim neovim bash-completion libftdi ccfits network-manager-applet xorg xorg-xinit lightdm adobe-source-code-pro-fonts --noconfirm --needed
sudo pacman -Sy python python-pip samba opencv pkgconfig gtest gmock wxgtk2 libmpdclient bc ranger xorg-server binutils keychain --needed --noconfirm
sudo pacman -Sy htop gtop unzip shadow perl-anyevent-i3 perl-json-xs git-lfs python-pywal fzf arandr pass --needed --noconfirm
sudo pacman -Sy zsh-syntax-highlighting openvpn diff-so-fancy networkmanager-openvpn zathura zathura-cb zathura-pdf-mupdf zathura-ps neomutt lynx ttf-dejavu --needed --noconfirm

git lfs install
git lfs pull

sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
sudo systemctl enable autofs
sudo systemctl start autofs

echo "Setting up oh-my-zsh ..."
if [ ! -d ~/.oh-my-zsh ]; then
    cd ~
    sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" --unattended
fi

if [ ! -d ~/.oh-my-zsh/themes/powerlevel10k ]; then
    cd ~/.oh-my-zsh/themes
    echo "Cloning powerlevel10k"
    git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
fi

echo "Copying default ranger config ..."
ranger --copy-config=all

echo "Setting up vim..."
BasicVimInstall

echo "Setting up git"
if grep -q "~/.scripts/gitalias" "~/.gitconfig" ; then
    echo "Git aliases already set up"
else
    echo "[include]" >> ~/.gitconfig
    echo "    path = ~/.scripts/gitalias" >> ~/.gitconfig
fi
if grep -q "~/.scripts/gitsetup" "~/.gitconfig" ; then
    echo "Git config already set up"
else
    echo "[include]" >> ~/.gitconfig
    echo "    path = ~/.scripts/gitsetup" >> ~/.gitconfig
fi

echo "Installing AUR packages"
InstallAurPackage "nerd-fonts-complete" "https://aur.archlinux.org/nerd-fonts-complete.git"
InstallAurPackage "xinit-xsession" "https://aur.archlinux.org/xinit-xsession.git"
InstallAurPackage "nrclient2-free" "https://aur.archlinux.org/nrclient2-free.git"
InstallAurPackage "cava" "https://aur.archlinux.org/cava.git"
InstallAurPackage "dcron" "https://aur.archlinux.org/dcron.git"

echo "Enabling services ..."
sudo systemctl enable dcron
sudo systemctl start dcron

echo "Applying default cron-config ..."
crontab ~/.defaultCronConfig

echo "Copying some default files ..."
cp $scriptDir/defaults/vscode_custom.css ~/vscode_custom.css
sudo rm -rf /usr/share/backgrounds/*
SetupBackgroundsFolderForBing
sh ~/.scripts/updateLoginBackground.sh # Execute it ones, to get a new background
