SetupBitBox() {
    if [ ! -f /etc/udev/rules.d/54-hid-bitbox02.rules ]
    then
        printf "SUBSYSTEM==\"usb\", TAG+=\"uaccess\", TAG+=\"udev-acl\", SYMLINK+=\"bitbox02_%%n\", ATTRS{idVendor}==\"03eb\", ATTRS{idProduct}==\"2403\"\n" | sudo tee /etc/udev/rules.d/53-hid-bitbox02.rules > /dev/null && printf "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"03eb\", ATTRS{idProduct}==\"2403\", TAG+=\"uaccess\", TAG+=\"udev-acl\", SYMLINK+=\"bitbox02_%%n\"\n" | sudo tee /etc/udev/rules.d/54-hid-bitbox02.rules > /dev/null
        printf "SUBSYSTEM==\"usb\", TAG+=\"uaccess\", TAG+=\"udev-acl\", SYMLINK+=\"dbb%%n\", ATTRS{idVendor}==\"03eb\", ATTRS{idProduct}==\"2402\"\n" | sudo tee /etc/udev/rules.d/51-hid-digitalbitbox.rules > /dev/null && printf "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"03eb\", ATTRS{idProduct}==\"2402\", TAG+=\"uaccess\", TAG+=\"udev-acl\", SYMLINK+=\"dbbf%%n\"\n" | sudo tee /etc/udev/rules.d/52-hid-digitalbitbox.rules > /dev/null
    fi
}