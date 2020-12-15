#!/bin/sh
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. ./functions.sh

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

chmod +x ~/.scripts/bashprofile
chmod +x ~/.scripts/xprofile
chmod +x ~/.i3/workspaces/load-workspaces.sh

echo "Setting up shares ..."
SetupAutofsForSmbShare "ATLANTIS-SRV" "Documents" "://10.0.0.2/Documents" "Downloads" "://10.0.0.2/Downloads" "Software" "://10.0.0.2/Software" "Astrophotography" "://10.0.0.2/Astrophotography" "Backup" "://10.0.0.2/Backup"

################################################
# Setup Digitec working envoirement
################################################
sudo cp $scriptDir/overrides/pacman.conf /etc/pacman.conf
sudo pacman-key --keyserver hkp://keyserver.ubuntu.com -r 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo pacman-key --lsign-key 7568D9BB55FF9E5287D586017AE645C0CF8E292A
SetupDigitecVpn

sudo pacman -Sy dotnet-sdk dotnet-runtime dotnet-host --noconfirm --needed

InstallAurPackage "visual-studio-code-bin" "https://aur.archlinux.org/visual-studio-code-bin.git"
InstallAurPackage "rider" "https://aur.archlinux.org/rider.git"
InstallAurPackage "xrdp" "https://aur.archlinux.org/xrdp.git"
InstallAurPackage "xorgxrdp" "https://aur.archlinux.org/xorgxrdp.git"

echo "Increasing inotify max watches ..."
if [ ! -f /etc/sysctl.conf ]
then
    echo "fs.inotify.max_user_watches = 1638400" | sudo tee -a /etc/sysctl.conf
    echo "fs.inotify.max_user_instances = 1638400" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
fi

if [ ! -d ~/.omnisharp ]
then
    mkdir ~/.omnisharp
fi

echo "Setting up omnisharp for vscode..."
rm -rf ~/.omnisharp
cp -Raf $scriptDir/../surface-book/overrides/omnisharp ~/.omnisharp

echo "Enabling services ..."
sudo systemctl enable xrdp
sudo systemctl start xrdp
sudo systemctl enable xrdp-sesman
sudo systemctl start xrdp-sesman

echo "Installing AzureDev Ops credential provider"
InstallAurPackage "azure-cli" "https://aur.archlinux.org/azure-cli.git"

wget https://dot.net/v1/dotnet-install.sh -O ~/Downloads/dotnet-install.sh
sudo ~/Downloads/dotnet-install.sh -channel Current -version latest --install-dir /usr/share/dotnet/

echo "Setting up xrdp ..."
sudo rm /etc/X11/Xwrapper.config
echo "allowed_users=anybody" | sudo tee /etc/X11/Xwrapper.config
