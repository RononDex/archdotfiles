# My personal dotfiles for arch linux

Using a profile enabler script to support different profiles / pc's and environments

# How to install

First, install Arch-Linux by following this guide: https://wiki.archlinux.org/index.php/Installation_guide

After you have followed and finished that guide (takes about 10 minutes), DON'T REBOOT JUST YET!

While still being chrooted into your local Arch-Linux install, install sudo and git:

```bash
pacman -Sy git sudo
```

Then setup your personal user with `useradd`, change its password with `passwd` and add it to the `/etc/sudoers` file

Now login with your new personal user by doing `su <username>`

Once you are logged in to your new user, go to your home directory `cd ~` and clone the git repository:

```bash
git clone https://github.com/RononDex/archdotfiles
```

Open the directory with `cd archdotfiles` and execute the installation script:

```
sh profile-enabler.sh
```

This will take a while to run, go grab a coffee or exercise :)
Once the script has finished, simply reboot into your finished and ready to use system (you might have to enter `exit` once during the installation process, it sometimes gets stuck in the zsh after installing it. After entering `exit` it will continue installation)

# data structure

This repository is structured into the following folders:

1. defaults: Contains all the default files that install all the base files into ~/
2. profiles: Contains one subfolder per profile, with overrides for the base profile.

![Screenshot](https://github.com/RononDex/archdotfiles/raw/master/Screenshot.png)
