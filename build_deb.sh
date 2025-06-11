#!/bin/bash

# This is a hacky little script to generate a deb.
#
# NOTE: This only works for building an arm64 .deb as is. Change
#       the Architecture below if desired.

architecture="arm64"
install_root="$(pwd)/build/deb/joycond"
package_version="0.4-0"

mkdir -p "$install_root" || exit
cmake . || exit
make DESTDIR="$install_root" install || exit

cd "$install_root" || exit

mkdir -p DEBIAN
cd DEBIAN || exit

cat <<EOF > control
Package: joycond
Architecture: $architecture
Maintainer: Daniel J. Ogorchock
Priority: optional
Version: $package_version
Description: Pairs joy-cons together into a virtual controller
Depends: libevdev2, libudev1
EOF

cat <<EOF > conffiles
EOF

cat <<EOF > postinst
#!/bin/bash
# Load the ledtrig-timer module for player LED blinking
modprobe ledtrig-timer

# Ensure runit service directory exists
mkdir -p /etc/runit/runsvdir/default

# Link the joycond service if it doesn't exist
if [ ! -L /etc/runit/runsvdir/default/joycond ]; then
    ln -s /usr/lib/joycond/runit/service/joycond /etc/runit/runsvdir/default/
fi
EOF
chmod 755 postinst

cd ../..

fakeroot dpkg-deb --build joycond || exit
