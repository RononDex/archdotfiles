#!/bin/sh
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

SetupDigitecVpn() {
    PURPLE='\033[0;35m'
    LIGHTBLUE='\033[1;34m'
    NC='\033[0m' # No Color

    echo "Setting up vpn..."
    sudo pacman -Sy pritunl-client-electron --noconfirm --needed
    sudo pacman -Sy pritunl-client-electron-numix-theme --noconfirm --needed
    sudo pacman -Sy wireguard-tools openresolv --noconfirm --needed

    echo ""
    echo -e "I ${PURPLE}Please open https://vpn.devinite.com in your browser and login${NC}"
    echo -e "I ${LIGHTBLUE}Then copy the pritunl:// url into this console and hit enter${NC}"
    read pritunl_url

    pritunl-client add $pritunl_url
}

InstallDigitecSpecificStuff() {
    sudo cp $scriptDir/overrides/pacman.conf /etc/pacman.conf
    sudo pacman-key --keyserver hkp://keyserver.ubuntu.com -r 7568D9BB55FF9E5287D586017AE645C0CF8E292A
    sudo pacman-key --lsign-key 7568D9BB55FF9E5287D586017AE645C0CF8E292A
    SetupDigitecVpn

    sudo pacman -Sy clamav dotnet-sdk dotnet-runtime dotnet-host --noconfirm --needed

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

    echo "Updating anti virus database..."
    sudo freshclam
    sudo systemctl start clamav-daemon
    sudo systemctl start clamav-daemon

    echo "Setting up omnisharp for vscode..."
    rm -rf ~/.omnisharp
    cp -Raf $scriptDir/../surface-book/overrides/omnisharp ~/.omnisharp

    echo "Enabling services ..."
    sudo systemctl enable xrdp
    sudo systemctl start xrdp
    sudo systemctl enable xrdp-sesman
    sudo systemctl start xrdp-sesman

    echo "Installing AzureDev Ops credential provider"
    wget https://raw.githubusercontent.com/microsoft/artifacts-credprovider/master/helpers/installcredprovider.sh -O ~/Downloads/installcredprovider.sh
    sh ~/Downloads/installcredprovider.sh
    InstallAurPackage "azure-cli" "https://aur.archlinux.org/azure-cli.git"

    wget https://dot.net/v1/dotnet-install.sh -O ~/Downloads/dotnet-install.sh
    sudo sh ~/Downloads/dotnet-install.sh -channel Current -version latest --install-dir /usr/share/dotnet/

    echo "Setting up xrdp ..."
    sudo rm /etc/X11/Xwrapper.config
    echo "allowed_users=anybody" | sudo tee /etc/X11/Xwrapper.config
}
