#!/bin/sh
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. $scriptDir/../../functions/astroFunctions.sh
. $scriptDir/../DigitecWork/functions.sh

sudo cp $scriptDir/overrides/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp $scriptDir/overrides/lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf
sudo cp $scriptDir/overrides/lightdm-bg.jpg /usr/share/lightdm-webkit/themes/litarvan/images/background.jpg
sudo cp $scriptDir/overrides/litarvan/styles.css /usr/share/lightdm-webkit/themes/litarvan/styles.css
cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
sudo cp $scriptDir/overrides/xorg/30-mouse.conf /etc/X11/xorg.conf.d/30-mouse.conf

mkdir ~/.i3
mkdir ~/.i3/workspaces
mkdir ~/.i3/scripts

cp $scriptDir/overrides/.i3/workspaces/load-workspaces.sh ~/.i3/workspaces/load-workspaces.sh
cp $scriptDir/overrides/.i3/workspaces/workspace-1.json ~/.i3/workspaces/workspace-1.json
cp $scriptDir/overrides/.i3/scripts/launch-autostart.sh ~/.i3/scripts/launch-autostart.sh

echo "Installing stuff..."
sudo pacman -Sy i3-gaps nvidia dunst libnotify notification-daemon dmenu flameshot nextcloud-client teamspeak3 cabextract blueman signal-desktop --noconfirm --needed
sudo pacman -Sy lib32-nvidia-utils remmina freerdp xf86-input-evdev pulseaudio-bluetooth prusa-slicer texlive-most --noconfirm --needed
sudo pacman -Sy rust rust-analyzer rust-racer --needed --noconfirm
sudo pacman -Sy dotnet-host dotnet-runtime dotnet-sdk dotnet-targeting-pack --needed --noconfirm

echo "Installing rust/cargo stuff ..."
cargo install rustfmt

if [ ! -d ~/.omnisharp ]
then
    mkdir ~/.omnisharp
fi

echo "Setting up omnisharp for vscode..."
rm -rf ~/.omnisharp
cp -Raf $scriptDir/../surface-book/overrides/omnisharp ~/.omnisharp

echo "Installing AUR packages..."
InstallAurPackage "nrclient2-free" "https://aur.archlinux.org/nrclient2-free.git"
InstallAurPackage "nvm" "https://aur.archlinux.org/nvm.git"
InstallAurPackage "polybar" "https://aur.archlinux.org/polybar.git"
InstallAurPackage "steam-fonts" "https://aur.archlinux.org/steam-fonts.git"
InstallAurPackage "python-vdf" "https://aur.archlinux.org/python-vdf.git"
InstallAurPackage "protontricks" "https://aur.archlinux.org/protontricks.git"
InstallAurPackage "bitwarden" "https://aur.archlinux.org/bitwarden.git"
InstallAurPackage "visual-studio-code-bin" "https://aur.archlinux.org/visual-studio-code-bin.git"
InstallAurPackage "ckb-next" "https://aur.archlinux.org/ckb-next.git"
InstallAurPackage "vdf" "https://github.com/ValvePython/vdf"
InstallAurPackage "openh264-git" "https://aur.archlinux.org/openh264-git.git"
InstallAurPackage "mutt-wizard-git" "https://aur.archlinux.org/mutt-wizard-git.git"
InstallAurPackage "protonmail-bridge" "https://aur.archlinux.org/protonmail-bridge.git"
InstallAurPackage "teams" "https://aur.archlinux.org/teams.git"
InstallAurPackage "tmpmail-git" "https://aur.archlinux.org/tmpmail-git.git"
InstallDigitecSpecificStuffForVpnRdp

echo "Setting up ledger nano"
InstallAurPackage "ledger-udev" "https://aur.archlinux.org/ledger-udev.git"
InstallAurPackage "ledger-live-bin" "https://aur.archlinux.org/ledger-live-bin.git"

echo "Installing screenkey"
sudo pacman -Sy python2-setuptools --needed --noconfirm
InstallAurPackage "python2-distutils-extra" "https://aur.archlinux.org/python2-distutils-extra.git"
InstallAurPackage "screenkey" "https://aur.archlinux.org/screenkey.git"

echo "Enabling services ..."
sudo systemctl enable lightdm.service
sudo systemctl enable ckb-next-daemon
sudo systemctl start ckb-next-daemon
sudo systemctl enable nrclient
sudo systemctl start nrclient

echo "Setup mail"
mw cron 5

currentUser=$(whoami)
sudo usermod -a -G lp ${currentUser}
sudo usermod -a -G input ${currentUser}
sudo usermod -a -G video ${currentUser}
sudo usermod -a -G uucp ${currentUser}
sudo usermod -a -G users ${currentUser}
sudo usermod -a -G audio ${currentUser}
sudo usermod -a -G radio ${currentUser}

chmod +x ~/.scripts/bashprofile
chmod +x ~/.scripts/xprofile
chmod +x ~/.i3/workspaces/load-workspaces.sh

echo "Setting up shares ..."
SetupAutofsForSmbShare "ATLANTIS-SRV" "Documents" "://192.168.1.12/Documents" "Downloads" "://192.168.1.12/Downloads" "Software" "://192.168.1.12/Software" "Astrophotography" "://192.168.1.12/Astrophotography" "Backup" "://192.168.1.12/Backup"
SetupAutofsForSmbShare "ATLANTIS-ASTRO-PI1" "data" "://10.42.0.1/data"
