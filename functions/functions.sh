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
        git stash
        git pull
        git stash pop
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
        sudo mkdir /shares/$1
        echo "/shares/$1 /etc/autofs/auto.$1 --timeout=600 --ghost" | sudo tee -a /etc/autofs/auto.master

        for ((i=2; i<=$#; i+=2)); do
            j=$((i+1))
            echo "${!i} -fstype=cifs,rw,noperm,uid=1000,credentials=/etc/autofs/$1-credentials ${!j}" | sudo tee -a /etc/autofs/auto.$1 
        done

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

# $1: interface name
# $2: hotspot name
# $3: 5GHz (true) or 2.4GHz (false)
SetupHotspot() {
    if [ ! -f  ~/.scripts/networking/startHotspot$2 ]; then
        BAND="a"
        if $3 -eq true; then BAND="a"; else BAND="bg"; fi

        passwd="test"
        confirmedPasswd="asdf"
        while [ $passwd != $confirmedPasswd ]
        do
            echo "Enter password for hotspot ${2}:"
            stty_orig=`stty -g`         # save original terminal setting.
            stty -echo                  # turn-off echoing.
            read passwd                 # read the password
            stty $stty_orig             # restore terminal setting.
            echo "Confirm password:"
            stty_orig=`stty -g`         # save original terminal setting.
            stty -echo                  # turn-off echoing.
            read confirmedPasswd        # read the password
            stty $stty_orig             # restore terminal setting.
        done

        sh ~/.scripts/networking/setupHotspot $1 $2 $BAND $passwd
        echo "#!/bin/sh" > ~/.scripts/networking/startHotspot$2
        echo "nmcli con up \"${2}\"" >> ~/.scripts/networking/startHotspot$2
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

    sudo pacman -Sy the_silver_searcher --noconfirm --needed
    InstallAurPackage "neovim-plug" "https://aur.archlinux.org/neovim-plug.git"
    pip3 install pynvim
    python ~/.config/nvim/plugged/vimspector/install_gadget.py --force-enable-csharp
}

SetupBackgroundsFolderForBing() {
    if [ ! -d /usr/share/backgrounds/currentBingImage ]
    then
        currentUser=$(whoami)
        sudo chown -R $currentUser:$currentUser /usr/share/backgrounds/
    fi
}
