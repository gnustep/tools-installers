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
# This script creates file lists of various precompiled MingW/MSYS packages
# found on the web site at www.mingw.org
# Currently, you just have to insert the file list into the nsis scripts
# by hand.

# Find absolute path to our main dir.
SRCDIR=`dirname $0`
SRCDIR=`cd $SRCDIR && pwd`
# Location of the MinGW packages in compressed format (last / is important)
DISTDIR=$SRCDIR/sources/mingw/
# Location of compiled packages
PACKAGEDIR=$SRCDIR/packages/
# Location of installed packages
INSTALLPKG=/mingw/var/cache/mingw-get/packages/
# Location where the MinGW packages are installed (for when we
# compile the nsis script).
INSTALLDIR="C:\\gnustepdev2"
# Extra install dir to add on to standard INSTALLDIR
EXTRADIR=
# Remove all the doc files
REMOVEDOC=no
# User install only (dlls only)
USER=no

EXTRADIR=""
while test $# != 0
do
  gs_option=
  case $1 in
    --msys | -s)
      EXTRADIR="\\msys\\1.0";;
    --nodoc | -d)
      REMOVEDOC=yes;;
    --user | -u)
      USER=yes;;
    *)
      break;;
  esac
  shift
done

SYSTEM_FILES="msysCORE"
SYSTEM_MINGW_FILES="binutils mingw-runtime w32api"
SYSTEM_GCC_FILES="gcc-core gcc-objc gcc-g++"
ALLFILES="$*"
if [ x$ALLFILES = x ]; then
  # Do mingw files by default
  EXTRADIR="\\mingw"
  ALLFILES="$SYSTEM_MINGW_FILES $SYSTEM_GCC_FILES"
fi

echo Looking for packages in $PACKAGEDIR and $DISTDIR and $INSTALLPKG
echo Looking for packages $ALLFILES
for file in $ALLFILES; do
  if [ `dirname $file` = "." ]; then
    fullname=`find $DISTDIR -name $file\* -prune`
    if [ "x$fullname" = x ]; then
      fullname=`find $PACKAGEDIR -name $file\* -prune`
    fi
    if [ "x$fullname" = x ]; then
      fullname=`find $INSTALLPKG -name $file\* -prune`
    fi
  else
    fullname=$file
  fi
  if [ "x$fullname" = x ]; then
    echo Could not find distribution for $file
  else
    echo Found $fullname
    echo "  Getting files..."
    rm -f $file-files.txt
    if [ -d "$fullname" ]; then
      # This is an install directory
      pushd $fullname
      # Remove common prefixes
      if [ -d usr ]; then
        cd usr/local
      fi
      if [ -d opt ]; then
        cd opt/local/i386-mingw32/
      fi
      files=`tar -Pcf - * | tar -t`
      popd
    else
      # This is an archive
      echo $fullname | grep -q lzma
      if [ $? = 1 ]; then 
        echo $fullname | grep -q xz
        if [ $? = 1 ]; then 
          echo $fullname | grep -q gz
          if [ $? = 1 ]; then 
            files=`unzip -l $fullname`
	  else
            files=`tar -ztf $fullname`
	  fi
	else
          files=`xzcat $fullname | tar -tf -`
	fi
      else
       files=`lzmadec $fullname | tar -tf -`
      fi
    fi
    cdir="nosuchdirectory"
    printdir=NO
    outfile=`basename $file`-files.txt

    # Print out all the install files
    echo "  ; Files from `basename $fullname`" > $outfile
    echo "  ; Files from `basename $fullname`" >> files-not-added.txt
    REMOVEIT=no
    for i in $files; do
      # Hackish way to find if the file has a / suffix
      # in which case it is a dir we do not want to print
      slashsuffix=`basename ${i}yes`
      if [ "$slashsuffix" = yes ]; then
        newdir=`dirname $i`/`basename $i`
      else
        newdir=`dirname $i`
      fi
      echo $i | grep -q doc
      if [ $? = 0 -a $REMOVEDOC = yes ]; then 
        REMOVEIT=yes
	echo "  $i" >> files-not-added.txt
      fi
      if [ $USER = yes ]; then
        # User only files (dlls)
        if [ `basename $i .dll` = `basename $i` ]; then 
          REMOVEIT=yes
	  echo "  $i" >> files-not-added.txt
        fi
      fi
      if [ "$cdir" != "$newdir" ]; then
        cdir=$newdir
        windir=`echo $newdir | tr '/' '\\'`
	if [ $windir != "." -a $REMOVEIT = no ]; then
	  RMDIR_LIST="$INSTDIR$EXTRADIR\\$windir $RMDIR_LIST"
	fi
        printdir=YES
        if [ "$slashsuffix" = yes ]; then
	  continue
	fi
      fi
      if [ $printdir = YES -a $REMOVEIT = no ]; then
	if [ $cdir = "." ]; then
          echo "  SetOutPath \"\$INSTDIR$EXTRADIR\"" >> $outfile
	else
          echo "  SetOutPath \"\$INSTDIR$EXTRADIR\\$windir\"" >> $outfile
	fi
	printdir=NO
      fi
      ii=`echo $i | tr '/' '\'`
      if [ $REMOVEIT = no ]; then
        echo "  File \"$INSTALLDIR$EXTRADIR\\$ii\"" >> $outfile
        DELETE_LIST="$INSTDIR$EXTRADIR\\$ii $DELETE_LIST"
      fi
      REMOVEIT=no
    done

    # Now print out all the files in the uninstall (delete) list
    outfile=`basename $file`-delete.txt
    echo "  ; Delete list for $file" > $outfile
    for i in $DELETE_LIST; do
      echo "  Delete \"\$INSTDIR$i\"" >> $outfile
    done
    # Now print out all the directories in the uninstall (delete) list
    outfile=`basename $file`-rmdir.txt
    echo "  ; rmdir list for $file" > $outfile
    for i in $RMDIR_LIST; do
      echo "  RMDir \"\$INSTDIR$i\"" >> $outfile
    done
  fi
done


