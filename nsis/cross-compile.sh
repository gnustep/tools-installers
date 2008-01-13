#
# Semi-automatic, useful reminder for how to cross compile packages
# Work in progress. Need to clean this up and make it useful...
#
# Usage:
# ./cross-compile.sh [gnustep] [all | ffcall | objc | make | base | gui | back]
#   gnustep - compile only gnustep pacakges (otherwise only dependancies)
#   all - compile all gnustep (otherwise compile all except ffcall, objc)
#   xxx - compile specific package

# Location of sources, packages, etc.  Change to suit
HOME_DIR=$HOME/Source/nsis
PACKAGE_DIR=$HOME/Source/nsis/packages
SOURCES_DIR=$HOME/Source/nsis/sources
GNUSTEP_DIR=/Local/Software/gstep/current

# Setup for cross-compile
PATH=/opt/local/bin:$PATH

make_package()
{
  echo "Configuring $PACKAGE"
  cd $SOURCES_DIR/build/${PACKAGE}*
  ./configure --prefix=/opt/local/i386-mingw32/ --host=i386-mingw32 CC=i386-mingw32-gcc $PACKAGE_CONFIG
  #./configure --prefix=/opt/local/i386-mingw32/ --host=i386-mingw32 --build=i386-mingw32 CC=i386-mingw32-gcc $PACKAGE_CONFIG
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    return
  fi
  echo "Making $PACKAGE"
  make
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    return
  fi
  sudo make install
  mkdir -p $PACKAGE_DIR/${PACKAGE}
  if [ $PACKAGE = jpeg ]; then
    make prefix=$PACKAGE_DIR/${PACKAGE} install
  else
    make DESTDIR=$PACKAGE_DIR/${PACKAGE}/ install
  fi
}

#
# Dependancies
#
if [ x$1 != xgnustep ]; then
  packages="gettext libiconv libxml zlib jpeg tiff"
  if [ x$1 != x ]; then
    packages=$*
  fi
  PACKAGE_CONFIG=
  for name in $packages; do
    PACKAGE=$name
    make_package
  done

  exit 0
fi

# Notes:
# libxml,libpng - need to change the XXX-config file so the path 
#    prefix is correct.

#
# GNUstep
#
# Setup for Cross-compile
if test -d /GNUstep/System/Library/Makefiles/; then
  . /GNUstep/System/Library/Makefiles/GNUstep-reset.sh
  . /GNUstep/System/Library/Makefiles/GNUstep.sh
fi
# Add GNUstep tools into path (for running plmerge, etc)
DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/GNUstep/System/Library/Libraries
PATH=$PATH:/usr/GNUstep/System/Tools

# FIXME:
#  autoconf says we should set --build same as --host during configuration,
#  but that fails.

#
# GNustep-make
#
if [ x$2 = x -o x$2 = xmake ]; then
  echo "========= Making GNUstep Make ========="
  cd $SOURCES_DIR/gstep
  rm -rf gnustep-make-*
  tar -zxf $GNUSTEP_DIR/gnustep-make-*tar.gz
  cd gnustep-make-*
  ./configure --prefix=/GNUstep --with-config-file=/GNUstep/GNUstep.conf --host=i386-mingw32 CC=/opt/local/bin/i386-mingw32-gcc
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  make
  sudo make install
  rm -rf $PACKAGE_DIR/gnustep-make/
  make DESTDIR=$PACKAGE_DIR/gnustep-make/ install
  # GNUstep-make needs to be configured and made on Windows separately
  # otherwise it will pick up the wrong programs. This patch should fix it
  pushd $PACKAGE_DIR/gnustep-make
  patch -p1 < $HOME_DIR/make-i386.patch
  popd
fi

  . /GNUstep/System/Library/Makefiles/GNUstep-reset.sh
  . /GNUstep/System/Library/Makefiles/GNUstep.sh
  
if [ x$2 = xall -o x$2 = xffcall ]; then
#
# ffcall
#
  echo "========= Making ffcall ========="
  cd $SOURCES_DIR/gstep
  rm -rf ffcall-*
  tar -zxf /Local/Software/gstep/startup/sources/ffcall-*tar.gz
  cd $SOURCES_DIR/gstep/ffcall-*
  ./configure --prefix=/opt/local/i386-mingw32/GNUstep/System --libdir=/opt/local/i386-mingw32/GNUstep/System/Library/Libraries --includedir=/opt/local/i386-mingw32/GNUstep/System/Library/Headers --enable-shared --disable-static --host=i386-mingw32 CC=/opt/local/bin/i386-mingw32-gcc
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  make
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  sudo make install
  mkdir -p $PACKAGE_DIR/ffcall
  rm -rf $PACKAGE_DIR/ffcall
  make DESTDIR=$PACKAGE_DIR/ffcall install
fi

#
# GNUstep objc
#
if [ x$2 = xall -o x$2 = xobjc ]; then
  echo "========= Making objc  ========="
  cd $SOURCES_DIR/gstep
  tar -zxf /Local/Software/gstep/startup/sources/gnustep-objc-*tar.gz
  cd $SOURCES_DIR/gstep/gnustep-objc-*
  make
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  sudo make install
  mkdir -p $PACKAGE_DIR/gnustep-objc/GNUstep/System/Library/Libraries
  mkdir -p $PACKAGE_DIR/gnustep-objc/GNUstep/System/Library/Headers
  mkdir -p $PACKAGE_DIR/gnustep-objc/GNUstep/System/Tools
  rm -rf $PACKAGE_DIR/gnustep-objc
  make DESTDIR=$PACKAGE_DIR/gnustep-objc install

fi
#
# GNUstep base
#
if [ x$2 = x -o x$2 = xbase ]; then
  echo "========= Making GNUstep Base  ========="
  cd $SOURCES_DIR/gstep
  rm -rf gnustep-base-*
  tar -zxf $GNUSTEP_DIR/gnustep-base-*tar.gz
  cd gnustep-base-*
  ./configure --prefix=/GNUstep --with-config-file=./GNUstep.conf --host=i386-mingw32 --with-xml-prefix=/opt/local/i386-mingw32 CC=/opt/local/bin/i386-mingw32-gcc
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  make
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  sudo make install
  mkdir -p $PACKAGE_DIR/gnustep-base/GNUstep/System/Library/Libraries
  mkdir -p $PACKAGE_DIR/gnustep-base/GNUstep/System/Library/Makefiles
  mkdir -p $PACKAGE_DIR/gnustep-base/GNUstep/System/Library/Headers
  mkdir -p $PACKAGE_DIR/gnustep-base/GNUstep/System/Tools
  rm -rf $PACKAGE_DIR/gnustep-base
  make DESTDIR=$PACKAGE_DIR/gnustep-base install
fi

#
# GNustep Gui
#
if [ x$2 = x -o x$2 = xgui ]; then
  echo "========= Making GNUstep GUI  ========="
  cd $SOURCES_DIR/gstep
  rm -rf gnustep-gui-*
  tar -zxf $GNUSTEP_DIR/gnustep-gui-*tar.gz
  cd gnustep-gui-*
  ./configure --prefix=/GNUstep --host=i386-mingw32 CC=/opt/local/bin/i386-mingw32-gcc
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  export CROSS_COMPILE=yes
  make
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  sudo make install
  mkdir -p $PACKAGE_DIR/gnustep-gui/GNUstep/System/Library/Libraries
  mkdir -p $PACKAGE_DIR/gnustep-gui/GNUstep/System/Library/Makefiles
  mkdir -p $PACKAGE_DIR/gnustep-gui/GNUstep/System/Library/Headers
  mkdir -p $PACKAGE_DIR/gnustep-gui/GNUstep/System/Tools
  rm -rf $PACKAGE_DIR/gnustep-gui
  make DESTDIR=$PACKAGE_DIR/gnustep-gui install
fi

#
# GNustep Back
#
if [ x$2 = x -o x$2 = xback ]; then
  echo "========= Making GNUstep Back  ========="
  cd $SOURCES_DIR/gstep
  rm -rf gnustep-back-*
  tar -zxf $GNUSTEP_DIR/gnustep-back-*tar.gz
  cd gnustep-back-*
  ./configure --prefix=/GNUstep --host=i386-mingw32 --without-x CC=/opt/local/bin/i386-mingw32-gcc
  gsexitstatus=$?
  if [ "$gsexitstatus" != 0 -o \! -f config.status ]; then
    gsexitstatus=1
    exit 1
  fi
  make
  gsexitstatus=$?
  if [ $gsexitstatus != 0 ]; then
    gsexitstatus=1
    exit
  fi
  sudo make install
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Libraries
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Makefiles
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Headers
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Tools
  rm -rf $PACKAGE_DIR/gnustep-back
  make DESTDIR=$PACKAGE_DIR/gnustep-back install
fi  

