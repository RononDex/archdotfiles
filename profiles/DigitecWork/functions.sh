#!/bin/sh

SetupDigitecVpn() {
    PURPLE='\033[0;35m'
    LIGHTBLUE='\033[1;34m'
    NC='\033[0m' # No Color

    echo "Setting up vpn..."
    sudo pacman -Sy pritunl-client-electron --noconfirm --needed
    sudo pacman -Sy pritunl-client-electron-numix-theme --noconfirm --needed

    echo ""
    echo -e "I ${PURPLE}Please open https://vpn.devinite.com in your browser and download the profile for pritunl${NC}"
    echo -e "I ${LIGHTBLUE}You can then import the profile using pritunl-client-electron${NC}"
    echo "Hit any key to conitnue"
    read
}
