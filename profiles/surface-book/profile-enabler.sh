#!/bin/sh
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. $scriptDir/../../functions/astroFunctions.sh

sudo cp $scriptDir/overrides/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp $scriptDir/overrides/lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf
sudo cp $scriptDir/overrides/lightdm-bg.jpg /usr/share/lightdm-webkit/themes/litarvan/images/background.jpg
sudo cp $scriptDir/overrides/litarvan/styles.css /usr/share/lightdm-webkit/themes/litarvan/styles.css
cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/xorg/21-touchpad.conf /etc/X11/xorg.conf.d/21-touchpad.conf
cp $scriptDir/overrides/.i3/workspaces/load-workspaces.sh ~/.i3/workspaces/load-workspaces.sh
cp $scriptDir/overrides/.i3/workspaces/workspace-1.json ~/.i3/workspaces/workspace-1.json
cp $scriptDir/overrides/.i3/scripts/launch-autostart.sh ~/.i3/scripts/launch-autostart.sh
cp $scriptDir/overrides/dunst/dunstrc ~/.config/dunst/dunstrc

if [ ! -d ~/.omnisharp ]
then
    mkdir ~/.omnisharp
fi

echo "Setting up omnisharp for vscode..."
rm -rf ~/.omnisharp
cp -Raf $scriptDir/overrides/omnisharp ~/.omnisharp

echo "Installing stuff..."
sudo pacman -Sy i3-gaps xf86-input-wacom dunst libnotify notification-daemon flameshot vlc dmenu flameshot teamspeak3 blueman --noconfirm --needed
sudo pacman -Sy texlive-most xournalpp --needed --noconfirm
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

echo "Installing AUR packages..."
echo "polybar..."
InstallAurPackage "nvm" "https://aur.archlinux.org/nvm.git"
InstallAurPackage "polybar" "https://aur.archlinux.org/polybar.git"
InstallAurPackage "signal-desktop-bin" "https://aur.archlinux.org/signal-desktop-bin.git"
InstallAurPackage "steam-fonts" "https://aur.archlinux.org/steam-fonts.git"
CloneOrUpdateGitRepoToPackages "keeweb" "https://aur.archlinux.org/keeweb.git"
InstallAurPackage "mono-nightly" "https://aur.archlinux.org/mono-nightly.git"
InstallAurPackage "nuget4" "https://aur.archlinux.org/nuget4.git"
InstallAurPackage "bitwarden" "https://aur.archlinux.org/bitwarden.git"
InstallAurPackage "visual-studio-code-bin" "https://aur.a--needed --noconfirmrchlinux.org/visual-studio-code-bin.git"
InstallAurPackage "msbuild-16-bin" "https://aur.archlinux.org/msbuild-16-bin.git"
InstallAurPackage "nodejs-azure-cli" "https://aur.archlinux.org/nodejs-azure-cli.git"

gpg --recv-key A87FF9DF48BF1C90
gpg --recv-key 4773BD5E130D1D45
InstallAurPackage "spotify" "https://aur.archlinux.org/spotify.git"

echo "Installing fix for surface book eraser ..."
sudo pip3 install -U evdev
CloneOrUpdateGitRepoToPackages "linux-surface-fix-eraser" "https://github.com/StollD/linux-surface-fix-eraser"
cd ~/packages/linux-surface-fix-eraser
sudo cp linux-surface-fix-eraser.py /usr/local/bin/
sudo cp linux-surface-fix-eraser.service /etc/systemd/system/
sudo systemctl enable --now linux-surface-fix-eraser

echo "Enabling lightdm ..."
sudo systemctl enable lightdm.service

echo "Setting up Touchscreen"
if grep -q "MOZ_USE_XINPUT2 DEFAULT=1" "/etc/security/pam_env.conf" ; then
    echo "Touchscreen stuff already setup"
else
    echo "\r\nMOZ_USE_XINPUT2 DEFAULT=1\r\n" | sudo tee -a /etc/security/pam_env.conf
    sudo mkdir /etc/nginx/sites-available
fi

echo "Setting up shares ..."
SetupAutofsForSmbShare "ATLANTIS-SRV" "/Documents ://10.0.0.2/Documents /Downloads ://10.0.0.2/Downloads /Software ://10.0.0.2/Software /Astrophotography ://10.0.0.2/Astrophotography /Backup ://10.0.0.2/Backup"

echo "Setting up astro stuff .."
sudo pacman -Sy gpsd libdc1394 kstars --noconfirm --needed
sudo pacman -Sy --noconfirm --needed opencv ccfits breeze-icons binutils patch cmake make libraw libindi gpsd gcc

CloneOrUpdateGitRepoToPackages "indi" "https://github.com/indilib/indi"
MakePackage "indi"
InstallAurPackage "erfa" "https://aur.archlinux.org/erfa.git"
CloneOrUpdateGitRepoToPackages "indi-3rdparty" "--depth=1 https://github.com/indilib/indi-3rdparty"
InstallIndiDriver "indi-gphoto"
InstallIndiDriver "libasi"
InstallIndiDriver "indi-asi"
InstallAurPackage "python-astropy" "https://aur.archlinux.org/python-astropy.git"
InstallAurPackage "wcslib62" "https://aur.archlinux.org/wcslib62.git"
InstallAurPackage "astrometry.net" "https://aur.archlinux.org/astrometry.net.git"
CloneOrUpdateGitRepoToPackages "phd2" "https://github.com/OpenPHDGuiding/phd2.git"
InstallPHD2

echo "Adjust user permissions"
currentUser=$(whoami)
sudo usermod -a -G lp ${currentUser}
sudo usermod -a -G input ${currentUser}
sudo usermod -a -G video ${currentUser}
sudo usermod -a -G uucp ${currentUser}
sudo usermod -a -G users ${currentUser}

chmod +x ~/.profile/bashprofile
chmod +x ~/.i3/workspaces/load-workspaces.sh
