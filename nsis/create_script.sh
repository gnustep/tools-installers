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
SYSTEM_FILES="msysCORE MSYS binutils tar vim -m mingwrt-3.15-mingw32-dev -m mingwrt-3.15-mingw32-dll -m w32api -m gettext -m libiconv -m zlib libxml -m jpeg libpng tiff -m gcc-core -m gcc-objc -m gcc-g++ -m gdb"
GSTEP_FILES="gnustep-make ffcall gnustep-objc gnustep-base gnustep-gui gnustep-back"
CAIRO_FILES="-m freetype -m fontconfig -m pixman -m cairo gnustep-cairo"

# Pick the package we are making
PACKAGES=$SYSTEM_FILES
INSTALLER="gnustep-system"
ARGS=
if [ x$1 = xgstep -o x$1 = xcore ]; then
  PACKAGES=$GSTEP_FILES
  INSTALLER="gnustep-core"
fi
if [ x$1 = xuser  ]; then
  PACKAGES=$SYSTEM_FILES
  INSTALLER="gnustep-user"
  ARGS=-u
fi
if [ x$1 = xcairo  ]; then
  PACKAGES=$CAIRO_FILES
  INSTALLER="gnustep-cairo"
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
  rm -f $package-files.txt
  rm -f $package-delete.txt
  rm -f $package-rmdir.txt
done
