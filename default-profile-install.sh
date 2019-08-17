#!/bin/sh

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

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

echo "Changing default shell to zsh"
if [[ "$SHELL" != "/bin/zsh" ]]
then
    chsh -s /bin/zsh
fi

echo "Configuring pacman ..."
sudo cp defaults/pacman.conf /etc/pacman.conf
sudo cp defaults/mirrorlist /etc/pacman.d/mirrorlist
sudo chmod 744 /etc/pacman.conf
sudo chmod 744 /etc/pacman.d/mirrorlist

rm ~/pacman.conf
rm ~/mirrorlist

echo "Installing stuff..."
sudo pacman -Sy powerline-fonts gcc boost ffmpeg make cmake otf-fira-code otf-fira-mono otf-fira-sans ttf-fira-code ttf-fira-mono ttf-fira-sans bash-completion zsh zsh-completions light git --noconfirm --needed
sudo pacman -Sy bash-completion networkmanager gnome-keyring network-manager-applet xorg xorg-xinit lightdm firefox adobe-source-code-pro-fonts neofetch --noconfirm --needed
sudo pacman -Sy lightdm-webkit-theme-litarvan feh xfce4-terminal compton alsa pulseaudio pulseaudio-jack pulseaudio-bluetooth pulseaudio-alsa pavucontrol arc-gtk-theme arc-icon-theme nautilus --noconfirm --needed
sudo pacman -Sy java-runtime-common jre-openjdk ntfs-3g autofs --noconfirm --needed
sudo pacman -Sy bash-completion networkmanager gnome-keyring libftdi ccfits network-manager-applet xorg xorg-xinit lightdm firefox adobe-source-code-pro-fonts --noconfirm --needed
sudo pacman -Sy python samba opencv pkgconfig gtest gmock wxgtk2 libmpdclient bc ranger w3m xorg-server binutils keychain --needed --noconfirm
sudo pacman -Sy htop perl-anyevent-i3 perl-json-xs --needed --noconfirm

sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
sudo systemctl enable autofs
sudo systemctl start autofs

echo "Setting up oh-my-zsh ..."
if [ ! -d ~/.oh-my-zsh ]
then
    cd ~
    sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [ ! -d ~/.oh-my-zsh/themes/powerlevel10k ]
then
    cd ~/.oh-my-zsh/themes
    echo "Cloning powerlevel10k"
    git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
fi

echo "Installing AUR packages"
InstallAurPackage "nerd-fonts-complete" "https://aur.archlinux.org/nerd-fonts-complete.git"
InstallAurPackage "xinit-xsession" "https://aur.archlinux.org/xinit-xsession.git"
InstallAurPackage "nrclient2-free" "https://aur.archlinux.org/nrclient2-free.git"
InstallAurPackage "debtap" "https://aur.archlinux.org/debtap.git"
InstallAurPackage "cava" "https://aur.archlinux.org/cava.git"

echo "Enabling nrclient ..."
sudo systemctl enable nrclient
sudo systemctl start nrclient

echo "Copying some default files ..."
cp defaults/vscode_custom.css ~/vscode_custom.css
