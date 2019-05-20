
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


echo "Installing stuff..."
sudo pacman -Sy  otf-fira-code