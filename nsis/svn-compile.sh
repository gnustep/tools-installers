#
# Compile gnustep current svn
CLEAN=no

# Location of sources, packages, etc.  Change to suit
HOME_DIR=/h/Source/nsis
PACKAGE_DIR=$HOME_DIR/packages
SOURCES_DIR=$HOME_DIR/sources

#
# GNUstep
#
#  . /GNUstep/System/Library/Makefiles/GNUstep.sh
export GNUSTEP_INSTALLATION_DOMAIN=SYSTEM

#
# GNustep-make
#
if [ x$1 = xall -o x$1 = xmake ]; then
  echo "========= Making GNUstep Make ========="
  cd $SOURCES_DIR/gstep-current
  #rm -rf gnustep-make-*
  #tar -zxf $GNUSTEP_DIR/gnustep-make-*tar.gz
  cd make
  if [ -f config.status -a $CLEAN = yes ]; then
    make distclean
  fi
  ./configure CFLAGS="-m32 -march=i386" --prefix=/GNUstep --with-layout=gnustep --with-config-file=/GNUstep/GNUstep.conf
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  make install
fi

if [ x$1 = xall -o x$1 = xlibffi ]; then
#
# libffi
#
  echo "========= Making libffi ========="
  cd $SOURCES_DIR/gstep
  #rm -rf libffi-*
  #tar -zxf /Local/Software/gstep/startup/sources/libffi-*tar.gz
  cd $SOURCES_DIR/gstep/libffi-*
  patch -N -p0 < ../libffi-includes.patch
  if [ -f config.status -a $CLEAN = yes ]; then
    make distclean
  fi
  ./configure --prefix=/GNUstep/System --libdir=/GNUstep/System/Library/Libraries --includedir=/GNUstep/System/Library/Headers --bindir=/GNUstep/System/Tools --enable-shared 
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  make LN=cp LN_S=cp
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  make install
  # FIXME: dll gets installed in wrong place
  mv /GNUstep/System/Library/bin/*dll /GNUstep/System/Tools
  rm -rf $PACKAGE_DIR/libffi
  mkdir -p $PACKAGE_DIR/libffi
  mkdir -p $PACKAGE_DIR/libffi/GNUstep/System/Tools
  mkdir -p $PACKAGE_DIR/libffi/GNUstep/System/Library/Libraries
  make DESTDIR=$PACKAGE_DIR/libffi install
fi

  . /GNUstep/System/Library/Makefiles/GNUstep-reset.sh
  . /GNUstep/System/Library/Makefiles/GNUstep.sh
  
#
# GNUstep objc (libobjc2)
#
if [ x$1 = x -o x$1 = xall -o x$1 = xobjc ]; then
  echo "========= Making objc  ========="
  cd $SOURCES_DIR/gstep-current/libobjc2*
  if [ $CLEAN = yes ]; then
    make clean
  fi
  make
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  make install
  # strip the dll
  #strip /GNUstep/System/Tools/objc-?.dll
  rm -rf $PACKAGE_DIR/gnustep-objc2
  mkdir -p $PACKAGE_DIR/gnustep-objc2/GNUstep/System/Library/Libraries
  mkdir -p $PACKAGE_DIR/gnustep-objc2/GNUstep/System/Library/Headers
  mkdir -p $PACKAGE_DIR/gnustep-objc2/GNUstep/System/Tools
  make DESTDIR=$PACKAGE_DIR/gnustep-objc2 install

fi

#
# GNustep-make
#
if [ x$1 = x -o x$1 = xall -o x$1 = xmake ]; then
  echo "========= Making GNUstep Make ========="
  cd $SOURCES_DIR/gstep-current
  #rm -rf gnustep-make-*
  #tar -zxf $GNUSTEP_DIR/gnustep-make-*tar.gz
  cd make
  if [ -f config.status -a $CLEAN = yes ]; then
    make distclean
  fi
  ./configure CFLAGS="-m32 -march=i386" --prefix=/GNUstep --with-layout=gnustep
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  make install
  rm -rf $PACKAGE_DIR/gnustep-make/
  make DESTDIR=$PACKAGE_DIR/gnustep-make/ install
fi

  . /GNUstep/System/Library/Makefiles/GNUstep-reset.sh
  . /GNUstep/System/Library/Makefiles/GNUstep.sh
  
#
# GNUstep base
#
if [ x$1 = x -o x$1 = xall -o x$1 = xbase ]; then
  echo "========= Making GNUstep Base  ========="
  cd $SOURCES_DIR/gstep-current
  #rm -rf gnustep-base-*
  #tar -zxf $GNUSTEP_DIR/gnustep-base-*tar.gz
  cd base
  if [ -f config.status -a $CLEAN = yes ]; then
    make distclean
  fi
  ./configure --with-installation-domain=SYSTEM --disable-xslt
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  make install
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  rm -rf $PACKAGE_DIR/gnustep-base
  mkdir -p $PACKAGE_DIR/gnustep-base/GNUstep/System/Library/Libraries
  mkdir -p $PACKAGE_DIR/gnustep-base/GNUstep/System/Library/Makefiles
  mkdir -p $PACKAGE_DIR/gnustep-base/GNUstep/System/Library/Headers
  mkdir -p $PACKAGE_DIR/gnustep-base/GNUstep/System/Tools
  make DESTDIR=$PACKAGE_DIR/gnustep-base install
fi

#
# GNustep Gui
#
if [ x$1 = x -o x$1 = xall -o x$1 = xgui ]; then
  echo "========= Making GNUstep GUI  ========="
  cd $SOURCES_DIR/gstep-current
  #rm -rf gnustep-gui-*
  #tar -zxf $GNUSTEP_DIR/gnustep-gui-*tar.gz
  cd gui
  if [ -f config.status -a $CLEAN = yes ]; then
    make distclean
  fi
  ./configure
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  make install
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  rm -rf $PACKAGE_DIR/gnustep-gui
  mkdir -p $PACKAGE_DIR/gnustep-gui/GNUstep/System/Library/Libraries
  mkdir -p $PACKAGE_DIR/gnustep-gui/GNUstep/System/Library/Makefiles
  mkdir -p $PACKAGE_DIR/gnustep-gui/GNUstep/System/Library/Headers
  mkdir -p $PACKAGE_DIR/gnustep-gui/GNUstep/System/Tools
  make DESTDIR=$PACKAGE_DIR/gnustep-gui install
fi

#
# GNustep Back
#
if [ x$1 = x -o x$1 = xall -o x$1 = xback ]; then
  echo "========= Making GNUstep Back  ========="
  cd $SOURCES_DIR/gstep-current
  #rm -rf gnustep-back-*
  #tar -zxf $GNUSTEP_DIR/gnustep-back-*tar.gz
  cd back
  if [ -f config.status -a $CLEAN = yes ]; then
    make distclean
  fi
  ./configure --enable-graphics=winlib
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  make install
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  rm -rf $PACKAGE_DIR/gnustep-back
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Libraries
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Makefiles
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Headers
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Tools
  make DESTDIR=$PACKAGE_DIR/gnustep-back install
fi  

#
# Cairo backend
#

if [ x$1 = xcairo ]; then

  echo "========= Making GNUstep Back (Cairo)  ========="
  cd $SOURCES_DIR/gstep
  cd gnustep-cairo
  if [ -f config.status ]; then
    make distclean
  fi
  ./configure --with-name=cairo --enable-graphics=cairo
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  make install
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  rm -rf $PACKAGE_DIR/gnustep-cairo
  mkdir -p $PACKAGE_DIR/gnustep-cairo/GNUstep/System/Library/Libraries
  mkdir -p $PACKAGE_DIR/gnustep-cairo/GNUstep/System/Library/Makefiles
  mkdir -p $PACKAGE_DIR/gnustep-cairo/GNUstep/System/Library/Headers
  mkdir -p $PACKAGE_DIR/gnustep-cairo/GNUstep/System/Tools
  make DESTDIR=$PACKAGE_DIR/gnustep-cairo install
fi

if [ x$1 = x -o x$1 = xall -o x$1 = xtheme ]; then

  echo "========= Making GNUstep WinUXTheme  ========="
  cd $SOURCES_DIR/gstep-current
  cd WinUXTheme
  if [ -f config.status -a $CLEAN = yes ]; then
    make distclean
  fi
  make install
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  rm -rf $PACKAGE_DIR/WinUXTheme
  mkdir -p $PACKAGE_DIR/WinUXTheme/GNUstep/System/Library/Libraries
  make DESTDIR=$PACKAGE_DIR/WinUXTHeme install
fi
