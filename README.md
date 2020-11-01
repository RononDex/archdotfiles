# My personal dotfiles for arch linux

Using a profile enabler script to support different profiles / pc's and environments

# How to install

First, install Arch-Linux by following this guide: https://wiki.archlinux.org/index.php/Installation_guide

After you have followed and finished that guide and having a bootloader setup (takes about 10 minutes), DON'T REBOOT JUST YET!

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
Once the script has finished, simply reboot into your finished and ready to use system (**you might have to enter `exit` once during the installation process, it sometimes gets stuck in the zsh after installing it. After entering `exit` it will continue installation**)

To upgrade your system (including the AUR packages) just enter `up` in your terminal. This will do a git pull of the dotfiles repository, and rerun the profile-enabler.sh with your installed profile.

# How it works

1. Copy all files from the folder `defaults` to your home directory
1. Run `default-profile-install.sh` which will install all the default stuff that is the same across all pc's
1. Run profile-enabler.sh lcoated in your chosen profile folder `profiles/[profileName]/profile-enabler.sh`

So to create your own profile, simply fork this repository and create your own profile in the `profiles` folder. The only mandatory files are `xprofile`, `bashprofile` and `profile-enabler.sh`

## Software installed by default (for all profiles)
For an up to date list check the file itself here https://github.com/RononDex/archdotfiles/raw/master/default-profile-install.sh

- zsh (with oh-my-zsh and powerlevel10k)
- networkmanager
- fonts
- pulseaudio
- ranger
- zathura
- lightdm (with webkit litarvan theme)
- ...

# Data Structure

This repository is structured into the following folders:

1. defaults: Contains all the default files that install all the base files into ~/
2. profiles: Contains one subfolder per profile, with overrides for the base profile.
3. functions: Contains several functions reused throughout the different shell scripts

![Screenshot](https://github.com/RononDex/archdotfiles/raw/master/Screenshot.png)
