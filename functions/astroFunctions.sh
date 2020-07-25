
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

InstallAstroPy() {
    if [ ! -d ${HOME}/packages/astropy ]; then
        cd ~/packages
        git clone --recursive git://github.com/astropy/astropy.git
        cd astropy
        pip3 install . -v
    fi
}

InstallAstrometryNet() {
    cd ~/packages
    mkdir astrometryNet
    cd astrometryNet
    wget http://astrometry.net/downloads/astrometry.net-latest.tar.gz
    tar xvzf astrometry.net-latest.tar.gz
    cd astrometry.net-*
    make
    make py
    make extra
    make install  # to put it in /usr/local/astrometry
}

InstallPHD2() {
    cd ~/packages/phd2
    mkdir -p compiled
    cd compiled
    cmake ..
    make
    sudo ln -sf /home/cobra/packages/phd2/compiled/phd2.bin /usr/bin/phd2
}
