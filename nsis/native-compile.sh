#
# Semi-automatic, useful reminder for how to native compile packages
# Work in progress. Need to clean this up and make it useful...
#
# Usage:
# ./native-compile.sh [gnustep] [all | ffcall | objc | make | base | gui | back]
#           - default (no args) compile only dependencies (xml, etc)
#   gnustep - compile only gnustep core 
#   all - compile all gnustep (including ffcall, objc)
#   xxx - compile specific package

# Location of sources, packages, etc.  Change to suit
HOME_DIR=/h/Source/nsis
PACKAGE_DIR=$HOME_DIR/packages
SOURCES_DIR=$HOME_DIR/sources
#GNUSTEP_DIR=/Local/Software/gstep/current

make_package()
{
  echo "Configuring $PACKAGE"
  cd $SOURCES_DIR/build/${PACKAGE}*
  if [ -f config.status ]; then
    make distclean
  fi
  if [ $PACKAGE = jpeg ]; then
    patch -N -p1 < ../../jpeg-6b-mingw.patch
  elif [ $PACKAGE = zlib ]; then
    patch -N -p1 < ../../zlib-1.2.3-mingw.patch
  fi
  if [ $PACKAGE != zlib ]; then
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
    make -f win32/Makefile.gcc CFLAGS="$CFLAGS"
  else
    make LN_S=cp
  fi
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    return
  fi
  if [ $PACKAGE = zlib ]; then
    make -f win32/Makefile.gcc CFLAGS="$CFLAGS" prefix=/mingw install
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
  else
    make DESTDIR=$PACKAGE_DIR/${PACKAGE}/ install
  fi
}

# Flags required for Win2K and perhaps other systems
CFLAGS="-g -O2 -fno-omit-frame-pointer -fstrict-aliasing"
export CFLAGS

#
# Dependancies
#
if [ x$1 != xgnustep ]; then
  packages="zlib libxml2 jpeg tiff libpng"
  if [ x$1 != x ]; then
    packages=$*
  fi
  PACKAGE_CONFIG=
  for name in $packages; do
    # Notes:
    # libgcrypt: Need to go into config.status and change ln -s to cp
    # gnutls: problem with lgl/time.h?
    PACKAGE=$name
    make_package
  done

  exit 0
fi

#
# GNUstep
#
#  . /GNUstep/System/Library/Makefiles/GNUstep.sh

#
# GNustep-make
#
# FIXME: Make sure to comment out the -fno-strict-aliasing in common.make
#
if [ x$2 = x -o x$2 = xall -o x$2 = xmake ]; then
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
  
if [ x$2 = xall -o x$2 = xffcall ]; then
#
# ffcall
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

