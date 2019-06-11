#!/bin/sh

InstallAurPackage() {
    if [ ! -d ~/packages ]
    then
        mkdir ~/packages
    fi

    if [ ! -d ~/packages/$1 ]
    then
        cd ~/packages
        git clone $2
    else
        cd ~/packages/$1
        git pull
    fi
    makepkg -sic
}

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo cp $scriptDir/overrides/lightdm-bg.jpg /usr/share/lightdm-webkit/themes/litarvan/images/background.jpg
sudo cp $scriptDir/overrides/litarvan/styles.css /usr/share/lightdm-webkit/themes/litarvan/styles.css
cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf

echo "Installing stuff..."
sudo pacman -Sy bash-completion zsh zsh-completions networkmanager gnome-keyring network-manager-applet xorg lightdm firefox adobe-source-code-pro-fonts i3-gaps --noconfirm

echo "Installing AUR packages..."
echo "polybar..."
InstallAurPackage "polybar" "https://aur.archlinux.org/polybar.git"

currentUser=$(whoami)
sudo usermod -G lp ${currentUser}
