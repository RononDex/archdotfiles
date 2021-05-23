#!/bin/sh
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. $scriptDir/../../functions/astroFunctions.sh
. $scriptDir/../../functions/bitbox.sh

sudo cp $scriptDir/overrides/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp $scriptDir/overrides/lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf
sudo cp $scriptDir/overrides/lightdm-bg.jpg /usr/share/lightdm-webkit/themes/litarvan/images/background.jpg
sudo cp $scriptDir/overrides/litarvan/styles.css /usr/share/lightdm-webkit/themes/litarvan/styles.css
cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
sudo cp $scriptDir/overrides/xorg/10-monitor.conf /etc/X11/xorg.conf.d/10-monitor.conf
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/xorg/21-touchpad.conf /etc/X11/xorg.conf.d/21-touchpad.conf
cp $scriptDir/overrides/.i3/workspaces/load-workspaces.sh ~/.i3/workspaces/load-workspaces.sh
cp $scriptDir/overrides/.i3/workspaces/workspace-1.json ~/.i3/workspaces/workspace-1.json
cp $scriptDir/overrides/.i3/scripts/launch-autostart.sh ~/.i3/scripts/launch-autostart.sh
cp $scriptDir/overrides/dunst/dunstrc ~/.config/dunst/dunstrc
cp $scriptDir/overrides/pacman.conf /etc/pacman.conf

echo "Setting up surface repo"
wget -qO - https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
        | sudo pacman-key --add -
sudo pacman-key --finger 56C464BAAC421453
sudo pacman-key --lsign-key 56C464BAAC421453


sudo chmod 744 /etc/pacman.conf


if [ ! -d ~/.omnisharp ]; then
    mkdir ~/.omnisharp
fi

echo "Setting up omnisharp for vscode..."
rm -rf ~/.omnisharp
cp -Raf $scriptDir/overrides/omnisharp ~/.omnisharp

echo "Installing stuff..."
sudo pacman -Sy i3-gaps nextcloud-client light xf86-input-wacom dunst libnotify notification-daemon vlc dmenu flameshot teamspeak3 blueman --noconfirm --needed
sudo pacman -Sy texlive-most pulseaudio-bluetooth aspnet-runtime xournalpp remmina signal-desktop --needed --noconfirm
sudo pacman -Sy linux-surface-headers linux-surface surface-ipts-firmware iptsd --needed --noconfirm
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

echo "Installing AUR packages..."
InstallAurPackage "nrclient2-free" "https://aur.archlinux.org/nrclient2-free.git"
InstallAurPackage "nvm" "https://aur.archlinux.org/nvm.git"
InstallAurPackage "polybar" "https://aur.archlinux.org/polybar.git"
InstallAurPackage "steam-fonts" "https://aur.archlinux.org/steam-fonts.git"
CloneOrUpdateGitRepoToPackages "keeweb" "https://aur.archlinux.org/keeweb.git"
InstallAurPackage "bitwarden" "https://aur.archlinux.org/bitwarden.git"
InstallAurPackage "visual-studio-code-bin" "https://aur.archlinux.org/visual-studio-code-bin.git"
InstallAurPackage "nodejs-azure-cli" "https://aur.archlinux.org/nodejs-azure-cli.git"
InstallAurPackage "openh264" "https://aur.archlinux.org/openh264.git"
InstallAurPackage "freerdp-git" "https://aur.archlinux.org/freerdp-git.git"
InstallAurPackage "mutt-wizard-git" "https://aur.archlinux.org/mutt-wizard-git.git"
InstallAurPackage "protonmail-bridge" "https://aur.archlinux.org/protonmail-bridge.git"
InstallAurPackage "teams" "https://aur.archlinux.org/teams.git"

echo "Installing screenkey"
sudo pacman -Sy python2-setuptools --needed --noconfirm
InstallAurPackage "python2-distutils-extra" "https://aur.archlinux.org/python2-distutils-extra.git"
InstallAurPackage "screenkey" "https://aur.archlinux.org/screenkey.git"

gpg --recv-key A87FF9DF48BF1C90
gpg --recv-key 4773BD5E130D1D45
InstallAurPackage "spotify" "https://aur.archlinux.org/spotify.git"

echo "Enabling services ..."
sudo systemctl enable lightdm.service
sudo systemctl enable nrclient
sudo systemctl start nrclient
sudo systemctl enable iptsd

echo "Setting up Touchscreen"
if grep -q "MOZ_USE_XINPUT2 DEFAULT=1" "/etc/security/pam_env.conf"; then
    echo "Touchscreen stuff already setup"
else
    echo "\r\nMOZ_USE_XINPUT2 DEFAULT=1\r\n" | sudo tee -a /etc/security/pam_env.conf
    sudo mkdir /etc/nginx/sites-available
fi

echo "Setting up shares ..."
SetupAutofsForSmbShare "ATLANTIS-SRV" "Documents" "://10.0.0.2/Documents" "Downloads" "://10.0.0.2/Downloads" "Software" "://10.0.0.2/Software" "Astrophotography" "://10.0.0.2/Astrophotography" "Backup" "://10.0.0.2/Backup"
SetupAutofsForSmbShare "ATLANTIS-ASTRO-PI1" "data" "://10.42.0.1/data"

echo "Setting up astronomy stuff .."
sudo pacman -Sy gpsd libdc1394 kstars --noconfirm --needed
sudo pacman -Sy --noconfirm --needed wcslib opencv ccfits netpbm breeze-icons binutils patch cmake make libraw libindi gpsd gcc

InstallAstroPy
CloneOrUpdateGitRepoToPackages "indi" "https://github.com/indilib/indi"
MakePackage "indi"
CloneOrUpdateGitRepoToPackages "indi-3rdparty" "--depth=1 https://github.com/indilib/indi-3rdparty"
InstallIndiDriver "fxload"
InstallIndiDriver "fxload-libusb"
InstallIndiDriver "indi-gphoto"
InstallIndiDriver "libasi"
InstallIndiDriver "libatik"
InstallIndiDriver "indi-atik"
InstallIndiDriver "indi-asi"
InstallIndiDriver "libqhy"
InstallIndiDriver "indi-qhy"
InstallAstrometryNet
DownloadIndexFiles
CloneOrUpdateGitRepoToPackages "phd2" "https://github.com/OpenPHDGuiding/phd2.git"
InstallPHD2

echo "Setup mail"
mw cron 5

echo "Adjust user permissions"
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

echo "Setting up BitBox ..."
SetupBitBox
