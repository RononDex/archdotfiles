#!/bin/sh
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. ${scriptDir}/functions.sh

################################################
# Setup Base OS
# Contains no Digitec specific instructions for the work envoirement
################################################
sudo cp $scriptDir/overrides/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp $scriptDir/overrides/lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf
sudo cp $scriptDir/overrides/lightdm-bg.jpg /usr/share/lightdm-webkit/themes/litarvan/images/background.jpg
cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
cp $scriptDir/overrides/.ssh/config ~/.ssh/config
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
cp $scriptDir/overrides/polybar/network-traffic.sh ~/.config/polybar/network-traffic.sh
mkdir ~/.screenlayout
cp $scriptDir/overrides/.screenlayout/3-screens.sh ~/.screenlayout/3-screens.sh

chmod +x ~/.screenlayout/3-screens.sh

mkdir ~/.i3
mkdir ~/.i3/workspaces
mkdir ~/.i3/scripts

cp -f $scriptDir/overrides/.i3/workspaces/load-workspaces.sh ~/.i3/workspaces/load-workspaces.sh
cp -f $scriptDir/overrides/.i3/workspaces/workspace-1.json ~/.i3/workspaces/workspace-1.json
cp -f $scriptDir/overrides/.i3/scripts/launch-autostart.sh ~/.i3/scripts/launch-autostart.sh

echo "Installing stuff..."
sudo pacman -Sy i3-gaps mesa dunst libnotify notification-daemon dmenu freerdp flameshot light-locker cabextract signal-desktop --noconfirm --needed
sudo pacman -Sy remmina xf86-video-intel libreoffice nextcloud-client --noconfirm --needed

echo "Installing AUR packages..."
InstallAurPackage "nrclient2-free" "https://aur.archlinux.org/nrclient2-free.git"
InstallAurPackage "nvm" "https://aur.archlinux.org/nvm.git"
InstallAurPackage "polybar" "https://aur.archlinux.org/polybar.git"
InstallAurPackage "bitwarden" "https://aur.archlinux.org/bitwarden.git"
InstallAurPackage "ckb-next" "https://aur.archlinux.org/ckb-next.git"

echo "Installing screenkey"
sudo pacman -Sy python2-setuptools --needed --noconfirm
InstallAurPackage "python2-distutils-extra" "https://aur.archlinux.org/python2-distutils-extra.git"
InstallAurPackage "screenkey" "https://aur.archlinux.org/screenkey.git"

gpg --recv-key A87FF9DF48BF1C90
gpg --recv-key 4773BD5E130D1D45
InstallAurPackage "spotify" "https://aur.archlinux.org/spotify.git"

if [ ! -d ~/Downloads ]
then
    mkdir ~/Downloads
fi

echo "Enabling services ..."
sudo systemctl enable lightdm.service
sudo systemctl enable ckb-next-daemon
sudo systemctl start ckb-next-daemon
sudo systemctl enable nrclient
sudo systemctl start nrclient

currentUser=$(whoami)
sudo usermod -a -G lp ${currentUser}
sudo usermod -a -G input ${currentUser}
sudo usermod -a -G video ${currentUser}
sudo usermod -a -G uucp ${currentUser}
sudo usermod -a -G users ${currentUser}
sudo usermod -a -G audio ${currentUser}

chmod +x ~/.scripts/bashprofile
chmod +x ~/.scripts/xprofile
chmod +x ~/.i3/workspaces/load-workspaces.sh

echo "Setting up shares ..."
SetupAutofsForSmbShare "ATLANTIS-SRV" "Documents" "://10.0.0.2/Documents" "Downloads" "://10.0.0.2/Downloads" "Software" "://10.0.0.2/Software" "Astrophotography" "://10.0.0.2/Astrophotography" "Backup" "://10.0.0.2/Backup"

################################################
# Setup Digitec working envoirement
################################################
InstallDigitecSpecificStuff
