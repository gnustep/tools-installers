#! /bin/sh
#
#  Copyright (C) 2005 Free Software Foundation, Inc.
#
#  Written by:	Adam Fedor <fedor@gnu.org>
#
#  This package is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License as
#  published by the Free Software Foundation; either version 2 of the
#  License, or (at your option) any later version.
#
#  This package is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
#  General Public License for more details.
#
#  You should have received a copy of the GNU General Public
#  License along with this package; if not, write to the Free
#  Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA
#
#--------------------------------------------------------------------
#
# This script creates the installer script for nsis. It's not really a
# full creation script. Heavy editing is necessary afterwards.
#

# Packages. The -m before the name means it goes in the mingw subdir
SYSTEM_FILES="mingw-get Console -m libopenssl-1.0.0-1-msys-1.0.13-dev -m libopenssl-1.0.0-1-msys-1.0.13-dll -m openssl -m libxml2 -m jpeg -m libpng -m tiff -m libgpg-error -m libgcrypt -m gnutls -m icu -m libao -m libsndfile"
GSTEP_FILES="gnustep-make libffi gnustep-objc gnustep-base gnustep-gui gnustep-back WinUXTheme"
CAIRO_FILES="-m freetype -m fontconfig -m pixman -m cairo gnustep-cairo"
DEV_FILES="svn -m glib -m pkg-config"

# Pick the package we are making
PACKAGES=
INSTALLER=
ARGS=
if [ x$1 = xsystem -o x$1 = xmsys ]; then
  PACKAGES=$SYSTEM_FILES
  INSTALLER="gnustep-system"
fi
if [ x$1 = xgstep -o x$1 = xcore ]; then
  PACKAGES=$GSTEP_FILES
  INSTALLER="gnustep-core"
fi
if [ x$1 = xcairo  ]; then
  PACKAGES=$CAIRO_FILES
  INSTALLER="gnustep-cairo"
fi
if [ x$1 = xdev  ]; then
  PACKAGES=$DEV_FILES
  INSTALLER="gnustep-devel"
fi
if [ x$1 = xlibxml2  ]; then
  PACKAGES="-m libxml2"
  INSTALLER="gnustep-libxml2"
fi
if [ x$1 = xlist  ]; then
  PACKAGES=`cat $2`
  INSTALLER="gnustep-`basename $2 _names.list`"
fi
if [ x"$INSTALLER" = x ]; then
  echo No package named. Use one of: system, core, dev
  exit 0
fi
  
OUTPATH=$INSTALLER-sections.nsi
TEMPFILE=temp-nsi

rm -f files-not-added.txt
# Create the file lists
for package in $PACKAGES; do
  if test $package = -m; then
    args="$ARGS -m"
    continue;
  fi
  echo $package |  grep -q msys
  if [ $? = 0 ]; then
    args="$ARGS --msys"
  fi
  ./file_lists.sh $args $package
  args=$ARGS
done

#
# Section list for files
#
let section=1
rm -f $TEMPFILE
echo " " > $TEMPFILE
for package in $PACKAGES; do
  if test $package = -m; then
    continue;
  fi
  package=`basename $package`
  echo "Section \"$package\" SEC0$section" >> $TEMPFILE
  echo "  SectionIn RO" >> $TEMPFILE
  cat $TEMPFILE $package-files.txt > $TEMPFILE-1
  mv $TEMPFILE-1 $TEMPFILE
  echo "SectionEnd" >> $TEMPFILE
  echo "" >> $TEMPFILE
  let section=$section+1
done

#
# Delete list
#
echo "" >> $TEMPFILE
echo "Section Uninstall" >> $TEMPFILE
for package in $PACKAGES; do
  if test $package = -m; then
    continue;
  fi
  package=`basename $package`
  cat $TEMPFILE $package-delete.txt > $TEMPFILE-1
  mv $TEMPFILE-1 $TEMPFILE
  echo "" >> $TEMPFILE
done

#
# RMDir list
#
# Reverse this first:
sort_list=`echo $PACKAGES | tr ' ' '\n' | sed '1!G;h;$!d'`
REV_PACKAGES=`echo $sort_list`

echo "" >> $TEMPFILE
for package in $REV_PACKAGES; do
  if test $package = -m; then
    continue;
  fi
  package=`basename $package`
  cat $TEMPFILE $package-rmdir.txt > $TEMPFILE-1
  mv $TEMPFILE-1 $TEMPFILE
  echo "" >> $TEMPFILE
done
echo "SectionEnd" >> $TEMPFILE
echo "" >> $TEMPFILE
mv $TEMPFILE $OUTPATH

# Remove the temporary files
for package in $PACKAGES; do
  if test $package = -m; then
    continue;
  fi
  package=`basename $package`
  rm -f $package-files.txt
  rm -f $package-delete.txt
  rm -f $package-rmdir.txt
done
