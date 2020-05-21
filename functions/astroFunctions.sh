
InstallIndiDrivers() {
    mkdir -p ~/packages/indi-3rdparty/build
    cd ~/packages/indi-3rdparty/build
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ~/packages/indi-3rdparty
    make -j4
    sudo make install
}

InstallIndiDriver() {
    mkdir ~/packages/indi-3rdparty/build/
    cd ~/packages/indi-3rdparty/build/
    mkdir $1
    cd $1
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ~/packages/indi-3rdparty/$1
    make -j4
    sudo make install
}

InstallPlanetaryImager() {
    cd ~/packages/PlanetaryImager
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr
    make all && sudo make install
}

InstallPHD2() {
    cd ~/packages/phd2
    mkdir -p compiled
    cd compiled
    cmake ..
    make
    sudo ln -sf /home/cobra/packages/phd2/compiled/phd2.bin /usr/bin/phd2
}

InstallAstrometryNet() {
    InstallAurPackage  "python-astropy-helpers" "https://aur.archlinux.org/python-astropy-helpers.git"
    InstallAurPackage "python-astropy" "https://aur.archlinux.org/python-astropy.git"
    InstallAurPackage "astrometry.net" "https://aur.archlinux.org/astrometry.net.git"
}
