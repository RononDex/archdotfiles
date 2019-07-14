#!/bin/sh

InstallAurPackage() {
    CloneOrUpdateGitRepoToPackages $1 $2
    cd ~/packages/$1
    makepkg -sic --noconfirm --needed
}

CloneOrUpdateGitRepoToPackages() {
    echo "Cloning / updating " $2
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
}