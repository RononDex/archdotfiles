
InstallIndiDrivers() {
    cd ~/packages/indi/build
    mkdir 3rdparty
    cd 3rdparty
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
    make
    sudo make install
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ../../3rdparty
    make
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