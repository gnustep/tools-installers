#
# Install latest MINGW packages (As of 2009-09-09)
#
SRCDIR=/h/Source/nsis/sources/mingw

# First: create a new dir to put all this stuff in
# e.g. mkdir /c/GNUstep-devel/mingw-new
#      cd /c/GNUstep-devel/mingw-new
#
echo === msysCORE ===
tar -zxvf $SRCDIR/msysCORE-1.0.11-bin.tar.gz
echo === tar ===
tar -zxvf $SRCDIR/tar-1.22-1-msys-1.0.11-bin.tar.gz
echo === vim ===
tar -zxvf $SRCDIR/vim-7.2-1-msys-1.0.11-bin.tar.gz

mkdir mingw
cd mingw
echo === mingwrt ===
tar -zxvf $SRCDIR/mingwrt-3.16-mingw32-dev.tar.gz
echo === mingwrt ===
tar -zxvf $SRCDIR/mingwrt-3.16-mingw32-dll.tar.gz
echo === w32api ===
tar -zxvf $SRCDIR/w32api-3.13-mingw32-dev.tar.gz
echo === binutils ===
tar -zxvf $SRCDIR/binutils-2.19.1-mingw32-bin.tar.gz
echo === crypt ===
tar -zxvf $SRCDIR/libcrypt-1.1_1-2-msys-1.0.11-dev.tar.gz
tar -zxvf $SRCDIR/libcrypt-1.1_1-2-msys-1.0.11-dll-0.tar.gz
echo === gettext ===
tar -zxvf $SRCDIR/gettext-0.17-1-msys-1.0.11-bin.tar.gz
echo === gettext ===
tar -zxvf $SRCDIR/gettext-0.17-1-msys-1.0.11-dev.tar.gz
echo === libiconv ===
tar -zxvf $SRCDIR/libiconv-1.13.1-1-msys-1.0.11-bin.tar.gz
echo === libiconv ===
tar -zxvf $SRCDIR/libiconv-1.13.1-1-msys-1.0.11-dev.tar.gz 
echo === libopenssl ===
tar -zxvf $SRCDIR/libopenssl-0.9.8k-1-msys-1.0.11-dev.tar.gz
echo === libopenssl ===
tar -zxvf $SRCDIR/libopenssl-0.9.8k-1-msys-1.0.11-dll-098.tar.gz

echo === GCC ===
tar -zxvf $SRCDIR/gmp-4.2.4-mingw32-dll.tar.gz
tar -zxvf $SRCDIR/mpfr-2.4.1-mingw32-dll.tar.gz
tar -zxvf $SRCDIR/gcc-c++-4.4.0-mingw32-bin.tar.gz
tar -zxvf $SRCDIR/gcc-c++-4.4.0-mingw32-dll.tar.gz
tar -zxvf $SRCDIR/gcc-core-4.4.0-mingw32-bin.tar.gz
tar -zxvf $SRCDIR/gcc-core-4.4.0-mingw32-dll.tar.gz
tar -zxvf $SRCDIR/gcc-objc-4.4.0-mingw32-bin.tar.gz
tar -zxvf $SRCDIR/gcc-objc-4.4.0-mingw32-dll.tar.gz
tar -jxvf $SRCDIR/gdb-6.8-mingw-3.tar.bz2 

# NOTE: pthread needs to be compiled from source


# Finish:
#   create /etc/fstab
#   edit /etc/profile and remove first '.' from PATH
#   create /bin/vi (shell script to call vim.exe)
cd ..
echo "exec vim \"\$@\"" > bin/vi
mv bin/rxvt.exe bin/rxvt-save.exe

