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
HOME_DIR=/h/Source/nsis
PACKAGE_DIR=$HOME_DIR/packages
SOURCES_DIR=$HOME_DIR/sources
#GNUSTEP_DIR=/Local/Software/gstep/current

make_package()
{
  echo "Cleaning $PACKAGE"
  cd $SOURCES_DIR/build/${PACKAGE}*
  if [ -f config.status ]; then
    make distclean
  fi
  # FIXME: Need a patch for libxml2 - xmlexports.h
  if [ $PACKAGE = jpeg ]; then
    patch -N -p1 < ../../jpeg-6b-mingw.patch
  elif [ $PACKAGE = zlib ]; then
    patch -N -p1 < ../../zlib-1.2.3-mingw.patch
  fi
  echo "Configuring $PACKAGE"
  if [ $PACKAGE != zlib -a $PACKAGE != pthread ]; then
    echo "./configure --prefix=/mingw $PACKAGE_CONFIG"
    ./configure --prefix=/mingw $PACKAGE_CONFIG
    gsexitstatus=$?
    if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
      gsexitstatus=1
      return
    fi
  fi
  echo "Making $PACKAGE"
  if [ $PACKAGE = zlib ]; then
    #make -f win32/Makefile.gcc CFLAGS="$CFLAGS"
    make -f win32/Makefile.gcc 
  elif [ $PACKAGE = pthread ]; then
    make clean GC
  else
    make LN_S=cp
  fi
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    return
  fi
  if [ $PACKAGE = zlib ]; then
    #make -f win32/Makefile.gcc CFLAGS="$CFLAGS" prefix=/mingw install
    make -f win32/Makefile.gcc prefix=/mingw install
  elif [ $PACKAGE = pthread ]; then
    cp pthread.h sched.h semaphore.h /mingw/include
    cp libpthreadGC2.a /mingw/lib
    cp libpthreadGC2.a /mingw/lib/libpthread.a
    cp pthreadGC2.dll /mingw/bin
  else
    make install
  fi
  mkdir -p $PACKAGE_DIR/${PACKAGE}
  if [ $PACKAGE = jpeg ]; then
    mkdir -p $PACKAGE_DIR/${PACKAGE}/bin
    mkdir -p $PACKAGE_DIR/${PACKAGE}/lib
    mkdir -p $PACKAGE_DIR/${PACKAGE}/man
    mkdir -p $PACKAGE_DIR/${PACKAGE}/man1
    make prefix=$PACKAGE_DIR/${PACKAGE} install
  elif [ $PACKAGE = zlib ]; then
    make -f win32/Makefile.gcc prefix=$PACKAGE_DIR/${PACKAGE} install
  elif [ $PACKAGE = pthread ]; then
    mkdir -p $PACKAGE_DIR/${PACKAGE}/bin
    mkdir -p $PACKAGE_DIR/${PACKAGE}/lib
    mkdir -p $PACKAGE_DIR/${PACKAGE}/include
    cp pthread.h sched.h semaphore.h $PACKAGE_DIR/${PACKAGE}/include
    cp libpthreadGC2.a $PACKAGE_DIR/${PACKAGE}/lib
    cp libpthreadGC2.a $PACKAGE_DIR/${PACKAGE}/lib/libpthread.a
    cp pthreadGC2.dll $PACKAGE_DIR/${PACKAGE}/bin
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
  packages="pthread zlib libxml2 jpeg tiff libpng libgpg-error libgcrypt gnutls"
  if [ x$1 != x ]; then
    packages=$*
  fi
  for name in $packages; do
    # Notes:
    PACKAGE=$name
    PACKAGE_CONFIG=
    if [ $PACKAGE = pthread ]; then
      PACKAGE_CONFIG=--with-threads=win32
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
  #rm -rf gnustep-make-*
  #tar -zxf $GNUSTEP_DIR/gnustep-make-*tar.gz
  cd gnustep-make-*
  if [ -f config.status ]; then
    make distclean
  fi
  ./configure --prefix=/GNUstep --with-config-file=/GNUstep/GNUstep.conf
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
  
if [ x$2 = xffcall ]; then
#
# ffcall (Deprecated)
#
  echo "========= Making ffcall ========="
  cd $SOURCES_DIR/gstep
  #rm -rf ffcall-*
  #tar -zxf /Local/Software/gstep/startup/sources/ffcall-*tar.gz
  cd $SOURCES_DIR/gstep/ffcall-*
  if [ -f config.status ]; then
    make distclean
  fi
  patch -N -p1 < ../ffcall-config.patch
  patch -N -p1 < ../ffcall-exec.patch
  ./configure --prefix=/GNUstep/System --libdir=/GNUstep/System/Library/Libraries --includedir=/GNUstep/System/Library/Headers --enable-shared 
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
  rm -rf $PACKAGE_DIR/ffcall
  mkdir -p $PACKAGE_DIR/ffcall
  mkdir -p $PACKAGE_DIR/ffcall/GNUstep/System/Library/Libraries
  make DESTDIR=$PACKAGE_DIR/ffcall install
fi

if [ x$2 = xall -o x$2 = xlibffi ]; then
#
# libffi
#
  echo "========= Making libffi ========="
  cd $SOURCES_DIR/gstep
  #rm -rf libffi-*
  #tar -zxf /Local/Software/gstep/startup/sources/libffi-*tar.gz
  cd $SOURCES_DIR/gstep/libffi-*
  #patch -N -p0 < ../libffi-includes.patch
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
  #tar -zxf /Local/Software/gstep/startup/sources/gnustep-objc-*tar.gz
  cd $SOURCES_DIR/gstep/gnustep-objc-*
  make clean
  make
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  make install
  # strip the dll
  strip /GNUstep/System/Tools/objc-1.dll
  rm -rf $PACKAGE_DIR/gnustep-objc
  mkdir -p $PACKAGE_DIR/gnustep-objc/GNUstep/System/Library/Libraries
  mkdir -p $PACKAGE_DIR/gnustep-objc/GNUstep/System/Library/Headers
  mkdir -p $PACKAGE_DIR/gnustep-objc/GNUstep/System/Tools
  make DESTDIR=$PACKAGE_DIR/gnustep-objc install

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
  ./configure --prefix=/GNUstep --with-config-file=/GNUstep/GNUstep.conf
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
  #rm -rf gnustep-base-*
  #tar -zxf $GNUSTEP_DIR/gnustep-base-*tar.gz
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
  #rm -rf gnustep-gui-*
  #tar -zxf $GNUSTEP_DIR/gnustep-gui-*tar.gz
  cd gnustep-gui-*
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
  #rm -rf gnustep-back-*
  #tar -zxf $GNUSTEP_DIR/gnustep-back-*tar.gz
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
