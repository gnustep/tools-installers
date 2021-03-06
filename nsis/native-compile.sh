#!/bin/sh
# Semi-automatic, useful reminder for how to native compile packages
# Work in progress. Need to clean this up and make it useful...
#
# Usage:
# ./native-compile.sh [gnustep] [all | libffi | objc | make | base | gui | back]
#           - default (no args) compile only dependencies (xml, etc)
#   gnustep - compile only gnustep core 
#   all - compile all gnustep (including libffi, objc)
#   xxx - compile specific package

# Location of sources, packages, etc.  Change to suit
HOME_DIR=/z/Source/nsis
PACKAGE_DIR=$HOME_DIR/packages
SOURCES_DIR=$HOME_DIR/sources
GNUSTEP_DIR=$HOME_DIR/sources/gstep/current

make_package()
{
  echo "Cleaning $PACKAGE"
  cd $SOURCES_DIR/build/${PACKAGE}*
  if [ -f config.status ]; then
    #make distclean
    make clean
  fi
  # FIXME: Need a patch for p11-kit (trying to link an .so file in ./p11-kit)
  if [ $PACKAGE = icu ]; then
    #patch -N -p1 -i < ../../icu4c-4_6-mingw-gnustep.diff
    cd source
  fi
  echo "Configuring $PACKAGE"
  if [ $PACKAGE != zlib ]; then
    if [ $PACKAGE = jpeg ]; then
      # Need this as gcc 4.6 screws up longjmp when there is no frame pointer
      # http://gcc.gnu.org/ml/gcc/2011-10/msg00324.html
      CFLAGS="-g -O2 -fno-omit-frame-pointer" ./configure --prefix=/mingw $PACKAGE_CONFIG
    elif [ $PACKAGE = mman ]; then
      ./configure --prefix=/mingw 
    else
      ./configure --prefix=/mingw $PACKAGE_CONFIG
      gsexitstatus=$?
      if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
        gsexitstatus=1
        return
      fi
    fi
  fi
  echo "Making $PACKAGE"
  if [ $PACKAGE = zlib ]; then
    #make -f win32/Makefile.gcc CFLAGS="$CFLAGS"
    make -f win32/Makefile.gcc 
  else
    make
  fi
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    return
  fi
  make install
  rm -rf $PACKAGE_DIR/${PACKAGE}
  mkdir -p $PACKAGE_DIR/${PACKAGE}
  if [ $PACKAGE = jpeg ]; then
    mkdir -p $PACKAGE_DIR/${PACKAGE}/bin
    mkdir -p $PACKAGE_DIR/${PACKAGE}/lib
    mkdir -p $PACKAGE_DIR/${PACKAGE}/man
    mkdir -p $PACKAGE_DIR/${PACKAGE}/man1
    make DESTDIR=$PACKAGE_DIR/${PACKAGE}/ install
  else
    make DESTDIR=$PACKAGE_DIR/${PACKAGE}/ install
  fi
}

# Flags required for Win2K and perhaps other systems
#CFLAGS="-g"
#export CFLAGS

#
# Dependancies
#
if [ x$1 != xgnustep ]; then
  packages="libxml2 jpeg tiff libpng libgpg-error libgcrypt p11-kit nettle gnutls icu libsndfile libao"
  if [ x$1 != x ]; then
    packages=$*
  fi
  for name in $packages; do
    # Notes:
    PACKAGE=$name
    PACKAGE_CONFIG="--enable-shared"
    if [ $PACKAGE = icu ]; then
      PACKAGE_CONFIG="$PACKAGE_CONFIG --libdir=/mingw/bin --disable-strict"
    fi
    if [ $PACKAGE = gnutls ]; then
      PACKAGE_CONFIG="$PACKAGE_CONFIG --with-libgcrypt --disable-guile"
    fi
    if [ $PACKAGE = libsndfile ]; then
      #PACKAGE_CONFIG="$PACKAGE_CONFIG --disable-alsa --disable-jack --disable-sqlite --disable-shave"
      PACKAGE_CONFIG="$PACKAGE_CONFIG --disable-shave"
    fi
    if [ $PACKAGE = fontconfig ]; then
      PACKAGE_CONFIG="$PACKAGE_CONFIG --enable-libxml2"
    fi
    make_package
  done

  exit 0
fi

#
# GNUstep
#
#  . /GNUstep/System/Library/Makefiles/GNUstep.sh
export GNUSTEP_INSTALLATION_DOMAIN=SYSTEM

#
# GNustep-make
#
#
if [ x$2 = xall -o x$2 = xmake ]; then
  echo "========= Making GNUstep Make ========="
  cd $SOURCES_DIR/gstep
  rm -rf gnustep-make-*
  tar -zxf $GNUSTEP_DIR/gnustep-make-*tar.gz
  cd gnustep-make-*
  if [ -f config.status ]; then
    make distclean
  fi
  ./configure --prefix=/GNUstep -with-layout=gnustep --with-config-file=/GNUstep/GNUstep.conf
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
  
if [ x$2 = xall -o x$2 = xlibffi ]; then
#
# libffi
#
  echo "========= Making libffi ========="
  cd $SOURCES_DIR/gstep
  #rm -rf libffi-*
  tar -zxf $GNUSTEP_DIR/libffi-*tar.gz
  cd $SOURCES_DIR/gstep/libffi-*
  patch -N -p0 < $HOME_DIR/libffi-includes*.patch
  if [ -f config.status ]; then
    make distclean
  fi
  ./configure --prefix=/GNUstep/System --libdir=/GNUstep/System/Library/Libraries --includedir=/GNUstep/System/Library/Headers  --bindir=/GNUstep/System/Tools --enable-shared 
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
  mv /GNUstep/System/Library/bin/*dll /GNUstep/System/Tools
  mv /GNUstep/System/Library/Libraries/libffi-3.0.13/include/* /GNUstep/System/Library/Headers
  rm -rf $PACKAGE_DIR/libffi
  mkdir -p $PACKAGE_DIR/libffi
  mkdir -p $PACKAGE_DIR/libffi/GNUstep/System/Tools
  mkdir -p $PACKAGE_DIR/libffi/GNUstep/System/Library/Libraries
  make DESTDIR=$PACKAGE_DIR/libffi install
fi

#
# GNUstep objc
#
if [ x$2 = xall -o x$2 = xobjc ]; then
  echo "========= Making objc  ========="
  cd $SOURCES_DIR/gstep
  #tar -zxf $GNUSTEP_DIR/gnustep-objc-*tar.gz
  cd $SOURCES_DIR/gstep-current/libobjc2*
  make clean
  make
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  make install
  # strip the dll
  #strip /GNUstep/System/Tools/objc-1.dll
  rm -rf $PACKAGE_DIR/gnustep-objc2
  mkdir -p $PACKAGE_DIR/gnustep-objc2/GNUstep/System/Library/Libraries
  mkdir -p $PACKAGE_DIR/gnustep-objc2/GNUstep/System/Library/Headers
  mkdir -p $PACKAGE_DIR/gnustep-objc2/GNUstep/System/Tools
  make DESTDIR=$PACKAGE_DIR/gnustep-objc2 install

fi

#
# GNustep-make (AGAIN!)
#
if [ x$2 = x -o x$2 = xall -o x$2 = xmake ]; then
  echo "========= Making GNUstep Make ========="
  cd $SOURCES_DIR/gstep
  #rm -rf gnustep-make-*
  #tar -zxf $GNUSTEP_DIR/gnustep-make-*tar.gz
  cd gnustep-make-*
  ./configure --prefix=/GNUstep -with-layout=gnustep --with-config-file=/GNUstep/GNUstep.conf
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  make install
  rm -rf $PACKAGE_DIR/gnustep-make/
  make DESTDIR=$PACKAGE_DIR/gnustep-make/ install
fi

#
# GNUstep base
#
if [ x$2 = x -o x$2 = xall -o x$2 = xbase ]; then
  echo "========= Making GNUstep Base  ========="
  cd $SOURCES_DIR/gstep
  rm -rf gnustep-base-*
  tar -zxf $GNUSTEP_DIR/gnustep-base-*tar.gz
  cd gnustep-base-*
  if [ -f config.status ]; then
    make distclean
  fi
  ./configure --disable-xslt --with-installation-domain=SYSTEM
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
if [ x$2 = x -o x$2 = xall -o x$2 = xgui ]; then
  echo "========= Making GNUstep GUI  ========="
  cd $SOURCES_DIR/gstep
  rm -rf gnustep-gui-*
  tar -zxf $GNUSTEP_DIR/gnustep-gui-*tar.gz
  cd gnustep-gui-*
  if [ -f config.status ]; then
    make distclean
  fi
  ./configure --with-include-flags=-fno-omit-frame-pointer
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  make messages=yes install
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
if [ x$2 = x -o x$2 = xall -o x$2 = xback ]; then
  echo "========= Making GNUstep Back  ========="
  cd $SOURCES_DIR/gstep
  rm -rf gnustep-back-*
  tar -zxf $GNUSTEP_DIR/gnustep-back-*tar.gz
  cd gnustep-back-*
  if [ -f config.status ]; then
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
  rm -rf $PACKAGE_DIR/gnustep-back
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Libraries
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Makefiles
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Headers
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Tools
  make DESTDIR=$PACKAGE_DIR/gnustep-back install
fi  

#
# GNustep WinUXTheme
#
if [ x$2 = x -o x$2 = xall -o x$2 = xtheme ]; then
  echo "========= Making GNUstep WinUXTheme  ========="
  cd $SOURCES_DIR/gstep-current
  cd WinUXTheme
  make install
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  rm -rf $PACKAGE_DIR/WinUXTheme
  mkdir -p $PACKAGE_DIR/WinUXTheme/GNUstep/System/Library/Libraries/Themes
  make DESTDIR=$PACKAGE_DIR/WinUXTheme install
fi  

#
# Cairo backend
#

if [ x$2 = xcairo ]; then

  # Make sure to install precompiled pacakages:
  # FIXME: bug in freetype - have to type make manually?!?!?!
  # FIXME: bug in cairo - need to add -lpthread to src/Makefile (?_LIBS)

  if [ x$3 = xall ]; then
    packages="freetype fontconfig pixman cairo"
    PACKAGE_CONFIG=
    for name in $packages; do
      PACKAGE=$name
      make_package
    done
  fi

  echo "========= Making GNUstep Back (Cairo)  ========="
  cd $SOURCES_DIR/gstep
  cd gnustep-cairo-*
  if [ -f config.status ]; then
    make distclean
  fi
  ./configure --enable-graphics=cairo --with-name=cairo
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

#
# Developer package
#

if [ x$2 = xdevel ]; then

  # Make sure to install precompiled pacakages:
  # perl

  if [ x$3 = xall ]; then
    packages="autoconf libtool"
    PACKAGE_CONFIG=
    for name in $packages; do
      PACKAGE=$name
      # FIXME Need to make in /usr
    done
  fi

fi
