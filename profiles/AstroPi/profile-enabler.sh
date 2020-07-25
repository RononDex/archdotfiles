#!/bin/sh
scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. $scriptDir/../../functions/astroFunctions.sh
. $scriptDir/../../functions/bitbox.sh

echo "Please ensure that Arch Linux ARM was correclty setup prior to launching this profile installer!"
echo "Exit with Ctrl+C if not setup properly yet"

echo "Copying some files..."
sudo cp $scriptDir/overrides/xorg/20-keybord.conf /etc/X11/xorg.conf.d/20-keyboard.conf
cp $scriptDir/overrides/.xinitrc ~/.xinitrc
cp $scriptDir/overrides/xfce4/terminalrc ~/.config/xfce4/terminal/terminalrc

echo "Setting up XFCE"
sudo pacman -Sy xfce4 firefox --noconfirm --needed

echo "Setting up network .."
InstallAurPackage "nrclient2-free" "https://aur.archlinux.org/nrclient2-free.git"

InstallAurPackage "libhdf5" "https://aur-dev.archlinux.org/libhdf5.git"

CloneOrUpdateGitRepoToPackages "indi" "https://github.com/indilib/indi"
InstallIndiDrivers
CloneOrUpdateGitRepoToPackages "phd2" "https://github.com/OpenPHDGuiding/phd2.git"
InstallPHD2

echo "Enabling services"
sudo systemctl enable nrclient
sudo systemctl start nrclient
sudo systemctl enable lightdm.service

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

CloneOrUpdateGitRepoToPackages "indi" "https://github.com/indilib/indi"
MakePackage "indi"
InstallAurPackage "erfa" "https://aur.archlinux.org/erfa.git"
CloneOrUpdateGitRepoToPackages "indi-3rdparty" "--depth=1 https://github.com/indilib/indi-3rdparty"
InstallIndiDriver "indi-gphoto"
InstallIndiDriver "libasi"
InstallIndiDriver "indi-asi"
InstallIndiDriver "libqhy"
InstallAstroPy
InstallAstrometryNet
CloneOrUpdateGitRepoToPackages "phd2" "https://github.com/OpenPHDGuiding/phd2.git"
InstallPHD2

echo "Setting up shares ..."
SetupAutofsForSmbShare "ATLANTIS-SRV" "/Documents ://10.0.0.2/Documents /Downloads ://10.0.0.2/Downloads /Software ://10.0.0.2/Software /Astrophotography ://10.0.0.2/Astrophotography /Backup ://10.0.0.2/Backup"

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
