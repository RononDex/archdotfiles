#!/bin/sh
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Please ensure that Arch Linux ARM was correclty setup prior to launching this profile installer!"
echo "Exit with Ctrl+C if not setup properly yet"

echo "Updating system"
sudo pacman -Syu --noconfirm

echo "Installing basic stuff / XFCE"
sudo pacman -S bash-completion zsh zsh-completions networkmanager gnome-keyring network-manager-applet xorg xfce4 lightdm --noconfirm
sudo systemctl enable NetworkManager

sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf

echo "Adjust user permissions"
currentUser=$(whoami)
sudo usermod -G lp ${currentUser}