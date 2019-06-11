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
    makepkg -sic
}

if [ ! -d ~/.oh-my-zsh ]
then
    sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [ ! -d ~/.oh-my-zsh/themes/powerlevel10k ]
then
    echo "Cloning powerlevel10k"
    git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
fi

echo "Updating file permissions ..."
chmod +x ~/.xinitrc
chmod +x ~/.profile/xprofile
chmod +x ~/.profile/bashprofile
chmod +x ~/.config/i3/config
chmod +x ~/.config/polybar/config
chmod +x ~/.config/polybar/launch.sh

echo "Changing default shell to zsh"
chsh -s /bin/zsh

echo "Installing stuff..."
sudo pacman -Sy otf-fira-code bash-completition zsh zsh-completitions light --noconfirm

echo "Installing AUR packages"
echo "nerd fonts ..."
InstallAurPackage "nerd-fonts-complete" "https://aur.archlinux.org/nerd-fonts-complete.git"

echo "Copying some default files ..."
cp defaults/vscode_custom.css ~/vscode_custom.css