#!/bin/sh
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo cp $scriptDir/overrides/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp $scriptDir/overrides/lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf
sudo cp $scriptDir/overrides/lightdm-bg.jpg /usr/share/lightdm-webkit/themes/litarvan/images/background.jpg
sudo cp $scriptDir/overrides/litarvan/styles.css /usr/share/lightdm-webkit/themes/litarvan/styles.css
cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/xorg/21-touchpad.conf /etc/X11/xorg.conf.d/21-touchpad.conf

if [ ! -d ~/.omnisharp ]
then
    mkdir ~/.omnisharp
fi

echo "Setting up omnisharp for vscode..."
rm -rf ~/.omnisharp
cp -Raf $scriptDir/overrides/omnisharp ~/.omnisharp

echo "Installing stuff..."
sudo pacman -Sy i3-gaps xf86-input-wacom flameshot vlc dmenu flameshot teamspeak3 --noconfirm --needed

echo "Installing AUR packages..."
echo "polybar..."
InstallAurPackage "polybar" "https://aur.archlinux.org/polybar.git"
InstallAurPackage "msbuild-stable" "https://aur.archlinux.org/msbuild-stable.git"
InstallAurPackage "signal" "https://aur.archlinux.org/signal.git"
InstallAurPackage "visual-studio-code-bin" "https://aur.archlinux.org/visual-studio-code-bin.git"
InstallAurPackage "steam-fonts" "https://aur.archlinux.org/steam-fonts.git"
CloneOrUpdateGitRepoToPackages "keeweb" "https://aur.archlinux.org/keeweb.git"
InstallAurPackage "nuget4" "https://aur.archlinux.org/nuget4.git"
InstallAurPackage "bitwarden" "https://aur.archlinux.org/bitwarden.git"

gpg --recv-key A87FF9DF48BF1C90
InstallAurPackage "spotify" "https://aur.archlinux.org/spotify.git"

echo "Enabling lightdm ..."
sudo systemctl enable lightdm.service

currentUser=$(whoami)
sudo usermod -G lp ${currentUser}
sudo usermod -G input ${currentUser}
sudo usermod -G video ${currentUser}
sudo usermod -G uucp ${currentUser}

chmod +x ~/.profile/bashprofile

echo "Setting up shares ..."
SetupAutofsForSmbShare "ATLANTIS-SRV" "/Documents ://10.0.0.2/Documents /Downloads ://10.0.0.2/Downloads /Software ://10.0.0.2/Software /Astrophotography ://10.0.0.2/Astrophotography /Backup ://10.0.0.2/Backup"