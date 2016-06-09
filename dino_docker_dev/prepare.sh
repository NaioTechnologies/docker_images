#!/bin/bash

cat > /etc/apt/sources.list <<EOF
deb http://ftp.fr.debian.org/debian jessie main
deb http://ftp.fr.debian.org/debian jessie-updates main
deb http://security.debian.org jessie/updates main
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
  libopencv-dev libglfw3-dev libglew-dev uuid-dev libusb-1.0-0-dev libblkid-dev libbluetooth-dev libjsoncpp-dev libudev-dev \
  python-pip socat can-utils ruby

# install extra packages from testing
echo "deb http://ftp.fr.debian.org/debian testing main" > /etc/apt/sources.list.d/testing.list
apt-get update && 
apt-get install -y libglm-dev

# install a decent version of cmake over the official one
wget -q https://cmake.org/files/v3.5/cmake-3.5.2-Linux-x86_64.tar.gz
tar xzf cmake-3.5.2-Linux-x86_64.tar.gz
cp -rf cmake-3.5.2-Linux-x86_64/* /usr/
rm -rf cmake-3.5.2-Linux-x86_64
rm -f cmake-3.5.2-Linux-x86_64.tar.gz

# remove testing from apt sources once it's done
rm -f /etc/apt/sources.list.d/testing.list
apt-get update

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
