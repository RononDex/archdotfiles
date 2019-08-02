# My personal dotfiles for arch linux
Using a profile enabler script to support different profiles / pc's and environments

# How to install
When you are installing Arch Linux from Live USB, simply arch-chroot into your local finished ARCH install, make sure sudo is set up and you are logged in with your personal user (not root !!), git clone this repository and execute
```
sh profile-enabler.sh
```
This will install everything needed. After installation has finished (takes some time) just reboot in your finished system and use xinitrc to login in lightdm

# data structure
This repository is structured into the following folders:
1. defaults:  Contains all the default files that install all the base files into ~/
2. profiles:  Contains one subfolder per profile, with overrides for the base profile.

![Screenshot](https://i.imgur.com/fyPg1Z1.jpg)
