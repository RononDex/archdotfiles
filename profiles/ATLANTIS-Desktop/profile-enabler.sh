#!/bin/sh
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo cp $scriptDir/overrides/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp $scriptDir/overrides/lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf
sudo cp $scriptDir/overrides/lightdm-bg.jpg /usr/share/lightdm-webkit/themes/litarvan/images/background.jpg
sudo cp $scriptDir/overrides/litarvan/styles.css /usr/share/lightdm-webkit/themes/litarvan/styles.css
cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf

echo "Installing stuff..."
sudo pacman -Sy i3-gaps nvidia lib32-nvidia-utils flameshoot --noconfirm --needed

echo "Installing AUR packages..."
echo "polybar..."
InstallAurPackage "polybar" "https://aur.archlinux.org/polybar.git"
InstallAurPackage "msbuild-stable" "https://aur.archlinux.org/msbuild-stable.git"
InstallAurPackage "signal" "https://aur.archlinux.org/signal.git"
InstallAurPackage "visual-studio-code-bin.git" "https://aur.archlinux.org/visual-studio-code-bin.git"
InstallAurPackage "steam-fonts1" "https://aur.archlinux.org/steam-fonts.git"

echo "Enabling lightdm ..."
sudo systemctl enable lightdm.service

currentUser=$(whoami)
sudo usermod -G lp ${currentUser}
