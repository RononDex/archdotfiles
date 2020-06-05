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

# $1: Name of share / server
# $2: shares to mount (command)
SetupAutofsForSmbShare() {

    if [ ! -d /shares ]
    then
        sudo mkdir /shares
    fi

    if ! grep -q "$1" "/etc/autofs/auto.master"; then
        echo "/shares /etc/autofs/auto.$1 --timeout=600 --ghost" | sudo tee -a /etc/autofs/auto.master

        echo "$1 -fstype=cifs,rw,noperm,uid=1000,credentials=/etc/autofs/$1-credentials $2" | sudo tee /etc/autofs/auto.$1

        echo "Username for $1 share: "
        read username

        echo "Password for $1 share: "
        stty_orig=`stty -g` # save original terminal setting.
        stty -echo          # turn-off echoing.
        read passwd         # read the password
        printf "username=$username\npassword=$passwd" | sudo tee /etc/autofs/$1-credentials > /dev/null
        stty $stty_orig     # restore terminal setting.

        sudo chmod 700 /etc/autofs/$1-credentials

        sudo systemctl restart autofs
    fi
}

MakePackage() {
    cd ~/packages/$1
    mkdir build
    cd build
    cmake ..
    make
}

BasicVimInstall() {
    if [ ! -d ~/.vim/bundle/Vundle.vim ]
    then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi

    InstallAurPackage "neovim-plug" "https://aur.archlinux.org/neovim-plug.git"
    pip3 install pynvim
}

SetupBackgroundsFolderForBing() {
    if [ ! -d /usr/share/backgrounds/currentBingImage ]
    then
        currentUser=$(whoami)
        sudo chown -R $currentUser:$currentUser /usr/share/backgrounds/
    fi
}
