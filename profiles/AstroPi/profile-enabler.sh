#!/bin/sh
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. $scriptDir/../../functions/astroFunctions.sh

echo "Please ensure that Arch Linux ARM was correclty setup prior to launching this profile installer!"
echo "Exit with Ctrl+C if not setup properly yet"

echo "Copying some files..."
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
cp $scriptDir/overrides/.xinitrc ~/.xinitrc
cp $scriptDir/overrides/xfce4/terminalrc ~/.config/xfce4/terminal/terminalrc
sudo cp $scriptDir/overrides/lightdm.conf /etc/lightdm/lightdm.conf
sudo cp $scriptDir/overrides/ssh/sshd_config /etc/ssh/sshd_config
sudo cp $scriptDir/overrides/lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf
sudo cp $scriptDir/overrides/xrdp/startwm.sh /etc/xrdp/startwm.sh

sudo chmod +x /etc/xrdp/startwm.sh

echo "Setting up XFCE"
sudo pacman -Sy xfce4 firefox --noconfirm --needed

echo "Installing stuff ..."
InstallAurPackage "xrdp" "https://aur.archlinux.org/xrdp.git"
InstallAurPackage "xorgxrdp" "https://aur.archlinux.org/xorgxrdp-git.git"

echo "Setting up xrdp ..."
sudo rm /etc/X11/Xwrapper.config
echo "allowed_users=anybody" | sudo tee /etc/X11/Xwrapper.config

echo "Setting up network .."
InstallAurPackage "libhdf5" "https://aur-dev.archlinux.org/libhdf5.git"

CloneOrUpdateGitRepoToPackages "indi" "https://github.com/indilib/indi"
InstallIndiDrivers
CloneOrUpdateGitRepoToPackages "phd2" "https://github.com/OpenPHDGuiding/phd2.git"
InstallPHD2

echo "Enabling services"
sudo systemctl enable lightdm.service
sudo systemctl enable xrdp
sudo systemctl start xrdp

echo "Setting up Touchscreen"
if grep -q "MOZ_USE_XINPUT2 DEFAULT=1" "/etc/security/pam_env.conf"; then
    echo "Touchscreen stuff already setup"
else
    echo "\r\nMOZ_USE_XINPUT2 DEFAULT=1\r\n" | sudo tee -a /etc/security/pam_env.conf
    sudo mkdir /etc/nginx/sites-available
fi

echo "Setting up astronomy stuff .."
sudo pacman -Sy gpsd libdc1394 kstars --noconfirm --needed
sudo pacman -Sy --noconfirm --needed wcslib opencv ccfits breeze-icons binutils patch cmake make libraw libindi gpsd gcc

InstallAstroPy
CloneOrUpdateGitRepoToPackages "indi" "https://github.com/indilib/indi"
MakePackage "indi"
CloneOrUpdateGitRepoToPackages "indi-3rdparty" "--depth=1 https://github.com/indilib/indi-3rdparty"
InstallIndiDriver "indi-gphoto"
InstallIndiDriver "libasi"
InstallIndiDriver "indi-asi"
InstallIndiDriver "libqhy"
InstallAstrometryNet
CloneOrUpdateGitRepoToPackages "phd2" "https://github.com/OpenPHDGuiding/phd2.git"
InstallPHD2

echo "Adjust user permissions"
currentUser=$(whoami)
sudo usermod -a -G lp ${currentUser}
sudo usermod -a -G input ${currentUser}
sudo usermod -a -G video ${currentUser}
sudo usermod -a -G uucp ${currentUser}
sudo usermod -a -G users ${currentUser}

sudo chown ${currentUser} ~/.xinitrc

chmod +x ~/.scripts/bashprofile
chmod +x ~/.scripts/xprofile
chmod +x ~/.config/xfce4/terminal/terminalrc
