#!/bin/sh

InstallAurPackage() {
    if [ ! -d ~/packages ]
    then
        mkdir ~/packages
    fi

    if [ ! -d ~/packages/$1 ]
    then
        cd ~/packages
        git clone $2
    else
        cd ~/packages/$1
        git pull
    fi
    cd ~/packages/$1
    makepkg -sic --noconfirm --needed
}