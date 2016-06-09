#!/bin/bash

cat > /etc/apt/sources.list <<EOF
deb http://archive.ubuntu.com/ubuntu xenial main universe
deb http://archive.ubuntu.com/ubuntu xenial-updates main universe
deb http://archive.ubuntu.com/ubuntu xenial-security main
EOF

# use internal proxy
APT_PROXY=192.168.1.44
cat > /etc/apt/apt.conf.d/01proxy <<EOF
Acquire::http::Proxy "http://$APT_PROXY:3142";
Acquire::https::Proxy "false";
EOF

# install packages from stable
apt-get update && 
apt-get install -y \
  locales wget git cmake zip strace apt-utils libpugixml-dev libjpeg-dev libtiff5-dev \
  libopencv-dev libglfw3-dev libglew-dev uuid-dev libusb-1.0-0-dev libblkid-dev libbluetooth-dev libjsoncpp-dev libudev-dev libglm-dev \
  python-pip socat can-utils ruby

# locale config
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

# install some extra stuff for testing purpose through pip
pip install robotframework robotframework-archivelibrary

# install 3rd party stuff
wget --quiet http://192.168.1.10/RadisRepo/3rd_party/ipp.tar.gz
wget --quiet http://192.168.1.10/RadisRepo/3rd_party/mvIMPACT_acquire.tar.gz
tar xzf ipp.tar.gz -C /opt/ intel/ipp/include intel/ipp/lib 
tar xzf mvIMPACT_acquire.tar.gz -C /opt/ mvIMPACT_acquire
rm -f ipp.tar.gz mvIMPACT_acquire.tar.gz

# googletest
git clone https://github.com/google/googletest.git
cd googletest
mkdir build
cd build
cmake -DBUILD_SHARED_LIBS=ON ..
make
make install

# asciidoctor-pdf
gem install --pre asciidoctor-pdf


ldconfig
