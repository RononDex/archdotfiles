#!/bin/sh
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo cp $scriptDir/overrides/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp $scriptDir/overrides/lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf
sudo cp $scriptDir/overrides/lightdm-bg.jpg /usr/share/lightdm-webkit/themes/litarvan/images/background.jpg
sudo cp $scriptDir/overrides/litarvan/styles.css /usr/share/lightdm-webkit/themes/litarvan/styles.css
cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/xorg/20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf
cp $scriptDir/overrides/polybar/network-traffic.sh ~/.config/polybar/network-traffic.sh
cp $scriptDir/overrides/xfce4/terminalrc ~/.config/xfce4/terminal/terminalrc
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
sudo pacman -Sy i3-gaps mesa dunst libnotify notification-daemon vlc dmenu flameshot light-locker cabextract --noconfirm --needed
sudo pacman -Sy remmina openldap xf86-video-intel --noconfirm --needed
sudo pacman -Sy nginx-mainline --noconfirm --needed

if [ ! -d ~/.omnisharp ]
then
    mkdir ~/.omnisharp
fi

echo "Setting up omnisharp for vscode..."
rm -rf ~/.omnisharp
cp -Raf $scriptDir/../surface-book/overrides/omnisharp ~/.omnisharp

echo "Installing AUR packages..."
InstallAurPackage "nvm" "https://aur.archlinux.org/nvm.git"
InstallAurPackage "polybar" "https://aur.archlinux.org/polybar.git"
InstallAurPackage "signal-desktop-bin" "https://aur.archlinux.org/signal-desktop-bin.git"
InstallAurPackage "xsp" "https://aur.archlinux.org/xsp.git"
InstallAurPackage "nuget4" "https://aur.archlinux.org/nuget4.git"
InstallAurPackage "bitwarden" "https://aur.archlinux.org/bitwarden.git"
InstallAurPackage "visual-studio-code-bin" "https://aur.archlinux.org/visual-studio-code-bin.git"
InstallAurPackage "ckb-next" "https://aur.archlinux.org/ckb-next.git"
InstallAurPackage "nodejs-azure-cli" "https://aur.archlinux.org/nodejs-azure-cli.git"
InstallAurPackage "rider" "https://aur.archlinux.org/rider.git"
InstallAurPackage "freerdp-git" "https://aur.archlinux.org/freerdp-git.git"
InstallAurPackage "openh264-git" "https://aur.archlinux.org/openh264-git.git"
InstallAurPackage "teams-for-linux" "https://aur.archlinux.org/teams-for-linux.git"

gpg --recv-key A87FF9DF48BF1C90
gpg --recv-key 4773BD5E130D1D45
InstallAurPackage "spotify" "https://aur.archlinux.org/spotify.git"

sudo pacman -Sy dotnet-sdk dotnet-runtime dotnet-host --noconfirm --needed

if [ ! -d ~/Downloads ]
then
    mkdir ~/Downloads
fi

echo "Installing AzureDev Ops credential provider"
wget https://raw.githubusercontent.com/microsoft/artifacts-credprovider/master/helpers/installcredprovider.sh -O ~/Downloads/installcredprovider.sh
sh ~/Downloads/installcredprovider.sh

wget https://dot.net/v1/dotnet-install.sh -O ~/Downloads/dotnet-install.sh
sudo ~/Downloads/dotnet-install.sh --install-dir /opt/dotnet -channel Current -version latest

echo "Enabling services ..."
sudo systemctl enable lightdm.service
sudo systemctl enable ckb-next-daemon
sudo systemctl start ckb-next-daemon

currentUser=$(whoami)
sudo usermod -a -G lp ${currentUser}
sudo usermod -a -G input ${currentUser}
sudo usermod -a -G video ${currentUser}
sudo usermod -a -G uucp ${currentUser}
sudo usermod -a -G users ${currentUser}

echo "Increasing inotify max watches ..."
if [ ! -f /etc/sysctl.conf ]
then
    echo "fs.inotify.max_user_watches = 1638400" | sudo tee -a /etc/sysctl.conf
    echo "fs.inotify.max_user_instances = 1638400" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
fi

echo "Setting up shares ..."
# SetupAutofsForSmbShare "ATLANTIS-SRV" "/Documents ://192.168.1.12/Documents /Downloads ://192.168.1.12/Downloads /Software ://192.168.1.12/Software /Astrophotography ://192.168.1.12/Astrophotography /Backup ://192.168.1.12/Backup"

echo "Setting up nginx ..."
if grep -q "fastcgi_param  SCRIPT_FILENAME    \$document_root\$fastcgi_script_name;" "/etc/nginx/fastcgi_params" ; then
    echo "nginx seems to already have been setup"
else
    echo "fastcgi_param  PATH_INFO          \"\";" | sudo tee -a /etc/nginx/fastcgi_params
    echo "fastcgi_param  SCRIPT_FILENAME    \$document_root\$fastcgi_script_name;" | sudo tee -a /etc/nginx/fastcgi_params
    sudo mkdir /etc/nginx/sites-available
fi