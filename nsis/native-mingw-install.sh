#
# Install latest MINGW packages (As of 2009-09-09)
#
SRCDIR=/h/Source/nsis/sources/mingw

# First: create a new dir to put all this stuff in
#
# mkdir /c/GNUstep-devel/mingw-new
# cd /c/GNUstep-devel/mingw-new
#
# Install msys packages
mingw-get install msys-base
# mingw-get instal ... (See DOWNLOADS for all packages)
#
# Create /etc/fstab
#  add /mingw and /GNUstep mountpoints
#
# Install mingw packages (See DOWNLODS)


#   edit /etc/profile and remove first '.' from PATH
#   create /bin/vi (shell script to call vim.exe)
cd ..
echo "exec vim \"\$@\"" > bin/vi
mv bin/rxvt.exe bin/rxvt-save.exe
# edit msys.bat. Add concole code
# Also get Console

