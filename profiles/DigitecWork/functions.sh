#!/bin/sh

SetupDigitecVpn() {
    PURPLE='\033[0;35m'
    LIGHTBLUE='\033[1;34m'
    NC='\033[0m' # No Color

    echo "Setting up vpn..."
    sudo pacman -Sy pritunl-client-electron --noconfirm --needed
    sudo pacman -Sy pritunl-client-electron-numix-theme --noconfirm --needed

    echo ""
    echo -e "I ${PURPLE}Please open https://vpn.devinite.com in your browser and login${NC}"
    echo -e "I ${LIGHTBLUE}Then copy the pritunl:// url into this console and hit enter${NC}"
    read pritunl_url

    pritunl-client add $pritunl_url
}
