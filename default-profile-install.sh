#!/bin/sh

sudo pacman -Sy wget git --noconfirm --needed

if [ ! -d ~/.oh-my-zsh ]
then
    cd ~
    sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [ ! -d ~/.oh-my-zsh/themes/powerlevel10k ]
then
    cd ~/.oh-my-zsh/themes
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
sudo pacman -Sy otf-fira-code bash-completition zsh zsh-completitions light git --noconfirm --needed
sudo pacman -Sy bash-completion zsh zsh-completions networkmanager gnome-keyring network-manager-applet xorg xorg-xinit lightdm firefox adobe-source-code-pro-fonts --noconfirm --needed
sudo pacman -Sy lightdm-webkit-theme-litarvan feh lxterminal compton --noconfirm --needed

sudo systemctl enable NetworkManager

echo "Installing AUR packages"
echo "nerd fonts ..."
InstallAurPackage "nerd-fonts-complete" "https://aur.archlinux.org/nerd-fonts-complete.git"
InstallAurPackage "xinit-xsession" "https://aur.archlinux.org/xinit-xsession.git"

echo "Copying some default files ..."
cp defaults/vscode_custom.css ~/vscode_custom.css