#!/bin/sh
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo cp $scriptDir/overrides/lightdm-bg.jpg /usr/share/lightdm-webkit/themes/litarvan/images/background.jpg
sudo cp $scriptDir/overrides/litarvan/styles.css /usr/share/lightdm-webkit/themes/litarvan/styles.css
cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/xorg/21-touchpad.conf /etc/X11/xorg.conf.d/21-touchpad.conf

if [ ! -d ~/.oh-my-zsh/themes/powerlevel10k ]
then
    mkdir ~/.omnisharp
fi

cp -Ra $scriptDir/overrides/omnisharp ~/.omnisharp

echo "Installing stuff..."
sudo pacman -Sy xf86-input-wacom --noconfirm

currentUser=$(whoami)
sudo usermod -G lp ${currentUser}
