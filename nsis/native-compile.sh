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
  ./configure $PACKAGE_CONFIG
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
  make install
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

#
# GNUstep
#
#  . /GNUstep/System/Library/Makefiles/GNUstep.sh

#
# GNustep-make
#
if [ x$2 = x -o x$2 = xmake ]; then
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
  make
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
  ./configure --prefix=/GNUstep/System --libdir=/GNUstep/System/Library/Libraries --includedir=/GNUstep/System/Library/Headers --enable-shared --disable-static 
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
  make install
  rm -rf $PACKAGE_DIR/ffcall
  mkdir -p $PACKAGE_DIR/ffcall
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
# GNUstep base
#
if [ x$2 = x -o x$2 = xbase ]; then
  echo "========= Making GNUstep Base  ========="
  cd $SOURCES_DIR/gstep
  #rm -rf gnustep-base-*
  #tar -zxf $GNUSTEP_DIR/gnustep-base-*tar.gz
  cd gnustep-base-*
  ./configure
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
  make install
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
if [ x$2 = x -o x$2 = xgui ]; then
  echo "========= Making GNUstep GUI  ========="
  cd $SOURCES_DIR/gstep
  #rm -rf gnustep-gui-*
  #tar -zxf $GNUSTEP_DIR/gnustep-gui-*tar.gz
  cd gnustep-gui-*
  ./configure
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
  make install
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
if [ x$2 = x -o x$2 = xback ]; then
  echo "========= Making GNUstep Back  ========="
  cd $SOURCES_DIR/gstep
  #rm -rf gnustep-back-*
  #tar -zxf $GNUSTEP_DIR/gnustep-back-*tar.gz
  cd gnustep-back-*
  ./configure
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
  make install
  rm -rf $PACKAGE_DIR/gnustep-back
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Libraries
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Makefiles
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Library/Headers
  mkdir -p $PACKAGE_DIR/gnustep-back/GNUstep/System/Tools
  make DESTDIR=$PACKAGE_DIR/gnustep-back install
fi  

