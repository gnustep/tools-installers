#
# Install latest MINGW packages (As of 2008-09-09)
#
SRCDIR=/h/Source/nsis/sources/mingw

# First: create a new dir to put all this stuff in
# e.g. mkdir /c/GNUstep-devel/mingw-new
#      cd /c/GNUstep-devel/mingw-new
#
tar -zxvf $SRCDIR/msysCORE-1.0.11-20080826.tar.gz 
cp bin/rvi bin/vi
tar -zxvf $SRCDIR/MSYS-1.0.11-20080821-dll.tar.gz 
tar -zxvf $SRCDIR/binutils-2.18.50-20080109-2.tar.gz 
tar -jxvf $SRCDIR/tar-1.13.19-MSYS-2005.06.08.tar.bz2 
tar -zxvf $SRCDIR/vim-7.1-MSYS-1.0.11-1-bin.tar.gz
mv mingw32 mingw
cd mingw
tar -zxvf $SRCDIR/mingwrt-3.15-mingw32-dev.tar.gz
tar -zxvf $SRCDIR/mingwrt-3.15-mingw32-dll.tar.gz
tar -zxvf $SRCDIR/w32api-3.12-mingw32-dev.tar.gz
tar -jxvf $SRCDIR/gettext-0.16.1-MSYS-1.0.11-1.tar.bz2 
tar -jxvf $SRCDIR/libiconv-1.11-MSYS-1.0.11-1.tar.bz2 
tar -zxvf $SRCDIR/gcc-core-3.4.5-20060117-3.tar.gz 
tar -zxvf $SRCDIR/gcc-g++-3.4.5-20060117-3.tar.gz 
tar -zxvf $SRCDIR/gcc-objc-3.4.5-20060117-3.tar.gz 
tar -jxvf $SRCDIR/gdb-6.8-mingw-3.tar.bz2 

# Finish:
#   create /etc/fstab
#   edit /etc/profile and remove first '.' from PATH
#   cp /bin/rvi /bin/vi - Also edit /bin/vi to remove -Z
#   edit /mingw/include/stdio.h and change __argv to f__argv
#   edit /mingw/include/stlib.h:317 and change inline to __inline__
#   mv /bin/rxvt.exe /bin/rxvt-save.exe



