#!/bin/sh
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

InstallIndiDrivers() {
    mkdir ~/packages/indi/build
    cd ~/packages/indi/build
    mkdir ~/packages/indi/build/3rdparty
    cd ~/packages/indi/build/3rdparty
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
    make
    sudo make install
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
    make
    sudo make install
}

InstallPlanetaryImager() {
    cd ~/packages/PlanetaryImager
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr
    make all && sudo make install
}

InstallPHD2() {
    cd ~/packages/phd2
    mkdir -p compiled
    cd compiled
    cmake ..
    make
    sudo ln -sf /home/cobra/packages/phd2/compiled/phd2.bin /usr/bin/phd2
}

sudo cp $scriptDir/overrides/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp $scriptDir/overrides/lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf
sudo cp $scriptDir/overrides/lightdm-bg.jpg /usr/share/lightdm-webkit/themes/litarvan/images/background.jpg
sudo cp $scriptDir/overrides/litarvan/styles.css /usr/share/lightdm-webkit/themes/litarvan/styles.css
cp $scriptDir/overrides/polybar/constants ~/.config/polybar/constants
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf

mkdir ~/.i3
mkdir ~/.i3/workspaces
mkdir ~/.i3/scripts

cp $scriptDir/overrides/.i3/workspaces/load-workspaces.sh ~/.i3/workspaces/load-workspaces.sh
cp $scriptDir/overrides/.i3/workspaces/workspace-1.json ~/.i3/workspaces/workspace-1.json
cp $scriptDir/overrides/.i3/scripts/launch-autostart.sh ~/.i3/scripts/launch-autostart.sh

echo "Installing stuff..."
sudo pacman -Sy i3-gaps nvidia vlc dunst libnotify notification-daemon dmenu flameshot teamspeak3 cabextract blueman --noconfirm --needed
sudo pacman -Sy lib32-nvidia-utils remmina prusa-slicer --noconfirm --needed
sudo nvidia-xconfig

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
InstallAurPackage "msbuild-stable" "https://aur.archlinux.org/msbuild-stable.git"
InstallAurPackage "signal-desktop-bin" "https://aur.archlinux.org/signal-desktop-bin.git"
InstallAurPackage "steam-fonts" "https://aur.archlinux.org/steam-fonts.git"
InstallAurPackage "keeweb" "https://aur.archlinux.org/keeweb.git"
InstallAurPackage "python-vdf" "https://aur.archlinux.org/python-vdf.git"
InstallAurPackage "protontricks" "https://aur.archlinux.org/protontricks.git"
InstallAurPackage "nuget4" "https://aur.archlinux.org/nuget4.git"
InstallAurPackage "bitwarden" "https://aur.archlinux.org/bitwarden.git"
InstallAurPackage "msbuild-16-bin" "https://aur.archlinux.org/msbuild-16-bin.git"
InstallAurPackage "visual-studio-code-bin" "https://aur.archlinux.org/visual-studio-code-bin.git"
InstallAurPackage "remmina-plugin-rdesktop" "https://aur.archlinux.org/remmina-plugin-rdesktop.git"
InstallAurPackage "ckb-next" "https://aur.archlinux.org/ckb-next.git"
InstallAurPackage "openhmd-git" "https://aur.archlinux.org/openhmd-git.git"
InstallAurPackage "SteamVR-OpenHMD" "https://github.com/ChristophHaag/SteamVR-OpenHMD"
MakePackage "SteamVR-OpenHMD"

# Setup Oculus HMD steam vr driver
ln -s /usr/lib/steamvr/openhmd ~/.steam/steam/steamapps/common/SteamVR/drivers/openhmd


gpg --recv-key A87FF9DF48BF1C90
InstallAurPackage "spotify" "https://aur.archlinux.org/spotify.git"

echo "installing astro stuff..."
InstallAurPackage "libhdf5" "https://aur-dev.archlinux.org/libhdf5.git"

CloneOrUpdateGitRepoToPackages "indi" "https://github.com/indilib/indi"
InstallIndiDrivers
CloneOrUpdateGitRepoToPackages "PlanetaryImager" "https://github.com/GuLinux/PlanetaryImager"
InstallPlanetaryImager
CloneOrUpdateGitRepoToPackages "phd2" "https://github.com/OpenPHDGuiding/phd2.git"
InstallPHD2

echo "Enabling services ..."
sudo systemctl enable lightdm.service
sudo systemctl enable ckb-next-daemon
sudo systemctl start ckb-next-daemon

currentUser=$(whoami)
sudo usermod -a -G lp ${currentUser}
sudo usermod -a -G input ${currentUser}
sudo usermod -a -G video ${currentUser}
sudo usermod -a -G uucp ${currentUser}

echo "Setting up shares ..."
SetupAutofsForSmbShare "ATLANTIS-SRV" "/Documents ://192.168.1.12/Documents /Downloads ://192.168.1.12/Downloads /Software ://192.168.1.12/Software /Astrophotography ://192.168.1.12/Astrophotography /Backup ://192.168.1.12/Backup"
