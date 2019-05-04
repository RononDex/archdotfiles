
if [ ! -d ~/.oh-my-zsh/themes/powerlevel10k ]
then
    echo "Cloning powerlevel10k"
    git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
fi


echo "Updating file permissions ..."
chmod +x ~/.xinitrc