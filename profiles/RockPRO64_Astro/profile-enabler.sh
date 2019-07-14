#!/bin/sh
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Please ensure that Arch Linux ARM was correclty setup prior to launching this profile installer!"
echo "Exit with Ctrl+C if not setup properly yet"

echo "Updating system"
sudo pacman -Syu --noconfirm

echo "Installing basic stuff / XFCE"
sudo pacman -Sy xfce4 --noconfirm --needed

sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf

echo "Installing Kstars, ekos and indi ..."
sudo pacman -Sy gpsd libdc1394 kstars --noconfirm --needed
sudo pacman -Sy --nnoconfirm --needed breeze-icons binutils patch cmake make libraw libindi gpsd gcc
CloneOrUpdateGitRepoToPackages "indi" "https://github.com/indilib/indi"
InstallIndiDrivers

echo "Adjust user permissions"
currentUser=$(whoami)
sudo usermod -G lp ${currentUser}
sudo usermod -G input ${currentUser}
sudo usermod -G video ${currentUser}


InstallIndiDrivers() {
    cd ~/packages/indi/build
    mkdir 3rdparty
    cd 3rdparty
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
    make
    sudo make install
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
    make
    sudo make install
}