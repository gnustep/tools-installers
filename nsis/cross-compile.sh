#
# Work in progress. Need to clean this up and make it useful...
#
# Semi-automatic, useful reminder for how to cross compile packages
#
#
PACKAGE_DIR=$HOME/Source/nsis/packages
SOURCES_DIR=$HOME/Source/nsis/sources

# Add GNUstep tools into path (for running plmerge, etc)
DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/GNUstep/System/Library/Libraries
PATH=$PATH:/usr/GNUstep/System/Tools

#
# Dependancies
#

cd ../tiff-3.8.2
./configure --prefix=/opt/local/i386-mingw32/ --host=i386-mingw32 --build==i386-mingw32 CC=i386-mingw32-gcc
make
sudo make install
make DESTDIR=/Users/fedor/Source/nsis/packages/tiff/ install


#
# GNUstep
#

#
# GNustep-make
#
cd gstep
tar -zxf /Local/Software/gstep/current/gnustep-make-2.0.2.tar.gz
cd gnustep-make-2.0.2/
./configure --prefix=/GNUstep --with-config-file=/GNUstep/GNUstep.conf --host=i386-mingw32 --build==i386-mingw32 CC=/opt/local/bin/i386-mingw32-gcc
make
sudo make install
# GNUstep-make needs to be configured and made on Windows separately
# otherwise it will pick up the wrong programs
#make DESTDIR=/Users/fedor/Source/nsis/packages/gnustep-make/ install
. /GNUstep/System/Library/Makefiles/GNUstep-reset.sh
. /GNUstep/System/Library/Makefiles/GNUstep.sh

#
# ffcall
#
tar -zxf /Local/Software/gstep/startup/sources/ffcall-1.10.tar.gz 
cd ffcall-1.10/
./configure --prefix=/opt/local/i386-mingw32/GNUstep/System --libdir=/opt/local/i386-mingw32/GNUstep/System/Library/Libraries --includedir=/opt/local/i386-mingw32/GNUstep/System/Library/Headers --enable-shared --disable-static --host=i386-mingw32 --build==i386-mingw32 CC=/opt/local/bin/i386-mingw32-gcc
make
sudo make install
make DESTDIR=/Users/fedor/Source/nsis/packages/ffcall install

#
# GNUstep objc
#
make
sudo make install
mkdir -p $PACKAGE_DIR/gnustep-objc/GNUstep/System/Library/Libraries
mkdir -p $PACKAGE_DIR/gnustep-objc/GNUstep/System/Library/Headers
mkdir -p $PACKAGE_DIR/gnustep-objc/GNUstep/System/Tools
make DESTDIR=/Users/fedor/Source/nsis/packages/gnustep-objc install

#
# GNUstep base
#
./configure --prefix=/GNUstep --with-config-file=./GNUstep.conf --host=i386-mingw32 --build==i386-mingw32 --with-xml-prefix=/opt/local/i386-mingw32 CC=/opt/local/bin/i386-mingw32-gcc
make
sudo make install
mkdir -p $PACKAGE_DIR/gnustep-base/GNUstep/System/Library/Libraries
mkdir -p $PACKAGE_DIR/gnustep-base/GNUstep/System/Library/Makefiles
mkdir -p $PACKAGE_DIR/gnustep-base/GNUstep/System/Library/Headers
mkdir -p $PACKAGE_DIR/gnustep-base/GNUstep/System/Tools
make DESTDIR=/Users/fedor/Source/nsis/packages/gnustep-base install

#
# GNustep Gui
#
/configure --prefix=/GNUstep --host=i386-mingw32 --build==i386-mingw32 CC=/opt/local/bin/i386-mingw32-gcc
export CROSS_COMPILE=yes
make
sudo make install
mkdir -p $PACKAGE_DIR/gnustep-gui/GNUstep/System/Library/Libraries
mkdir -p $PACKAGE_DIR/gnustep-gui/GNUstep/System/Library/Makefiles
mkdir -p $PACKAGE_DIR/gnustep-gui/GNUstep/System/Library/Headers
mkdir -p $PACKAGE_DIR/gnustep-gui/GNUstep/System/Tools
make DESTDIR=/Users/fedor/Source/nsis/packages/gnustep-gui install

#
# GNustep Back
#
/configure --prefix=/GNUstep --host=i386-mingw32 --build==i386-mingw32 --without-x CC=/opt/local/bin/i386-mingw32-gcc
make
sudo make install
mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Libraries
mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Makefiles
mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Headers
mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Tools
make DESTDIR=/Users/fedor/Source/nsis/packages/gnustep-back install
