; gnustep-cairo installer script
; Written: Adam Fedor <fedor@gnu.org>
; Date: Aug 2012
;
; This installer installs the GNUstep cairo backend
;
; Script generated with help from HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "GNUstep Windows Cairo"
!define PRODUCT_VERSION "0.31.0"
!define PRODUCT_PUBLISHER "GNUstep"
!define PRODUCT_WEB_SITE "http://www.gnustep.org"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\GNUstep"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "gnustep-cairo-${PRODUCT_VERSION}-setup.exe"
SetCompressor lzma
XPStyle on

Var CAIRO_BACKEND

; MUI 2.X compatible ------
!include "MUI2.nsh"

!include nsDialogs.nsh
!include "LogicLib.nsh"
!addincludedir "include"
!include "PathManipulation.nsh"
!include "GNUstepCairo.nsh"
!addplugindir "plugins"


; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "gnustep-cairo-LICENSE.rtf"
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Start menu page
Var ICONS_GROUP
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "GNUstep"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Select the Cairo Backend
Page Custom CairoBackendPage CairoBackendLeave
; Finish page
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\gnustep-cairo-README.rtf"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; Reserve files
ReserveFile '${NSISDIR}\Plugins\InstallOptions.dll'

; MUI end ------

;
;InstallDir "$PROGRAMFILES\GNUstep"
InstallDir "C:\GNUstep"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
 
Section "glib" SEC01
  #SectionIn RO
  ; Files from glib-2.18.1-2.tar.gz
  SetOutPath "$INSTDIR\bin"
  File "C:\gnustepdev\bin\gspawn-win32-helper-console.exe"
  File "C:\gnustepdev\bin\gspawn-win32-helper.exe"
  File "C:\gnustepdev\bin\libgio-2.0-0.dll"
  File "C:\gnustepdev\bin\libglib-2.0-0.dll"
  File "C:\gnustepdev\bin\libgmodule-2.0-0.dll"
  File "C:\gnustepdev\bin\libgobject-2.0-0.dll"
  File "C:\gnustepdev\bin\libgthread-2.0-0.dll"
SectionEnd

Section "freetype" SEC02
  SectionIn RO
  ; Files from freetype
  SetOutPath "$INSTDIR\bin"
  File "C:\gnustepdev\bin\freetype-config"
  File "C:\gnustepdev\bin\libfreetype-6.dll"
  SetOutPath "$INSTDIR\include\freetype2\freetype\config"
  File "C:\gnustepdev\include\freetype2\freetype\config\ftconfig.h"
  File "C:\gnustepdev\include\freetype2\freetype\config\ftheader.h"
  File "C:\gnustepdev\include\freetype2\freetype\config\ftmodule.h"
  File "C:\gnustepdev\include\freetype2\freetype\config\ftoption.h"
  File "C:\gnustepdev\include\freetype2\freetype\config\ftstdlib.h"
  SetOutPath "$INSTDIR\include\freetype2\freetype"
  File "C:\gnustepdev\include\freetype2\freetype\freetype.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftadvanc.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftbbox.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftbdf.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftbitmap.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftbzip2.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftcache.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftchapters.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftcid.h"
  File "C:\gnustepdev\include\freetype2\freetype\fterrdef.h"
  File "C:\gnustepdev\include\freetype2\freetype\fterrors.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftgasp.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftglyph.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftgxval.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftgzip.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftimage.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftincrem.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftlcdfil.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftlist.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftlzw.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftmac.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftmm.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftmodapi.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftmoderr.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftotval.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftoutln.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftpfr.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftrender.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftsizes.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftsnames.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftstroke.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftsynth.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftsystem.h"
  File "C:\gnustepdev\include\freetype2\freetype\fttrigon.h"
  File "C:\gnustepdev\include\freetype2\freetype\fttypes.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftwinfnt.h"
  File "C:\gnustepdev\include\freetype2\freetype\ftxf86.h"
  File "C:\gnustepdev\include\freetype2\freetype\t1tables.h"
  File "C:\gnustepdev\include\freetype2\freetype\ttnameid.h"
  File "C:\gnustepdev\include\freetype2\freetype\tttables.h"
  File "C:\gnustepdev\include\freetype2\freetype\tttags.h"
  File "C:\gnustepdev\include\freetype2\freetype\ttunpat.h"
  SetOutPath "$INSTDIR\include"
  File "C:\gnustepdev\include\ft2build.h"
  SetOutPath "$INSTDIR\lib"
  File "C:\gnustepdev\lib\libfreetype.a"
  File "C:\gnustepdev\lib\libfreetype.dll.a"
  File "C:\gnustepdev\lib\libfreetype.la"
  SetOutPath "$INSTDIR\lib\pkgconfig"
  File "C:\gnustepdev\lib\pkgconfig\freetype2.pc"
  SetOutPath "$INSTDIR\share\aclocal"
  File "C:\gnustepdev\share\aclocal\freetype2.m4"
SectionEnd

Section "fontconfig" SEC03
  SectionIn RO
  ; Files from fontconfig
  SetOutPath "$INSTDIR\bin"
  File "C:\gnustepdev\bin\fc-cache.exe"
  File "C:\gnustepdev\bin\fc-cat.exe"
  File "C:\gnustepdev\bin\fc-list.exe"
  File "C:\gnustepdev\bin\fc-match.exe"
  File "C:\gnustepdev\bin\fc-pattern.exe"
  File "C:\gnustepdev\bin\fc-query.exe"
  File "C:\gnustepdev\bin\fc-scan.exe"
  File "C:\gnustepdev\bin\libfontconfig-1.dll"
  SetOutPath "$INSTDIR\etc\fonts"
  File "C:\gnustepdev\etc\fonts\fonts.conf"
  File "C:\gnustepdev\etc\fonts\fonts.dtd"
  SetOutPath "$INSTDIR\etc\fonts\conf.d"
  File "C:\gnustepdev\etc\fonts\conf.d\README"
  SetOutPath "$INSTDIR\include\fontconfig"
  File "C:\gnustepdev\include\fontconfig\fcfreetype.h"
  File "C:\gnustepdev\include\fontconfig\fcprivate.h"
  File "C:\gnustepdev\include\fontconfig\fontconfig.h"
  SetOutPath "$INSTDIR\lib"
  File "C:\gnustepdev\lib\fontconfig.def"
  File "C:\gnustepdev\lib\libfontconfig.a"
  File "C:\gnustepdev\lib\libfontconfig.dll.a"
  File "C:\gnustepdev\lib\libfontconfig.la"
  SetOutPath "$INSTDIR\share\man\man1"
  File "C:\gnustepdev\share\man\man1\fc-cache.1"
  File "C:\gnustepdev\share\man\man1\fc-cat.1"
  File "C:\gnustepdev\share\man\man1\fc-list.1"
  File "C:\gnustepdev\share\man\man1\fc-match.1"
  File "C:\gnustepdev\share\man\man1\fc-pattern.1"
  File "C:\gnustepdev\share\man\man1\fc-query.1"
  File "C:\gnustepdev\share\man\man1\fc-scan.1"
SectionEnd

Section "pixman" SEC04
  SectionIn RO
  ; Files from pixman
  SetOutPath "$INSTDIR\bin"
  File "C:\gnustepdev\bin\libpixman-1-0.dll"
  SetOutPath "$INSTDIR\include\pixman-1"
  File "C:\gnustepdev\include\pixman-1\pixman-version.h"
  File "C:\gnustepdev\include\pixman-1\pixman.h"
  SetOutPath "$INSTDIR\lib"
  File "C:\gnustepdev\lib\libpixman-1.a"
  File "C:\gnustepdev\lib\libpixman-1.dll.a"
  File "C:\gnustepdev\lib\libpixman-1.la"
  SetOutPath "$INSTDIR\lib\pkgconfig"
  File "C:\gnustepdev\lib\pkgconfig\pixman-1.pc"
SectionEnd

Section "cairo" SEC05
  SectionIn RO
  ; Files from cairo
  SetOutPath "$INSTDIR\bin"
  File "C:\gnustepdev\bin\libcairo-2.dll"
  File "C:\gnustepdev\bin\libcairo-script-interpreter-2.dll"
  SetOutPath "$INSTDIR\include\cairo"
  File "C:\gnustepdev\include\cairo\cairo-deprecated.h"
  File "C:\gnustepdev\include\cairo\cairo-features.h"
  File "C:\gnustepdev\include\cairo\cairo-ft.h"
  File "C:\gnustepdev\include\cairo\cairo-pdf.h"
  File "C:\gnustepdev\include\cairo\cairo-ps.h"
  File "C:\gnustepdev\include\cairo\cairo-script-interpreter.h"
  File "C:\gnustepdev\include\cairo\cairo-svg.h"
  File "C:\gnustepdev\include\cairo\cairo-version.h"
  File "C:\gnustepdev\include\cairo\cairo-win32.h"
  File "C:\gnustepdev\include\cairo\cairo.h"
  SetOutPath "$INSTDIR\lib"
  File "C:\gnustepdev\lib\libcairo-script-interpreter.a"
  File "C:\gnustepdev\lib\libcairo-script-interpreter.dll.a"
  File "C:\gnustepdev\lib\libcairo-script-interpreter.la"
  File "C:\gnustepdev\lib\libcairo.a"
  File "C:\gnustepdev\lib\libcairo.dll.a"
  File "C:\gnustepdev\lib\libcairo.la"
  SetOutPath "$INSTDIR\lib\pkgconfig"
  File "C:\gnustepdev\lib\pkgconfig\cairo-fc.pc"
  File "C:\gnustepdev\lib\pkgconfig\cairo-ft.pc"
  File "C:\gnustepdev\lib\pkgconfig\cairo-pdf.pc"
  File "C:\gnustepdev\lib\pkgconfig\cairo-png.pc"
  File "C:\gnustepdev\lib\pkgconfig\cairo-ps.pc"
  File "C:\gnustepdev\lib\pkgconfig\cairo-svg.pc"
  File "C:\gnustepdev\lib\pkgconfig\cairo-win32-font.pc"
  File "C:\gnustepdev\lib\pkgconfig\cairo-win32.pc"
  File "C:\gnustepdev\lib\pkgconfig\cairo.pc"
  SetOutPath "$INSTDIR\share\gtk-doc\html\cairo"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\bindings-errors.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\bindings-fonts.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\bindings-memory.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\bindings-overloading.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\bindings-path.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\bindings-patterns.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\bindings-return-values.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\bindings-streams.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\bindings-surfaces.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-cairo-device-t.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-cairo-font-face-t.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-cairo-font-options-t.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-cairo-matrix-t.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-cairo-pattern-t.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-cairo-scaled-font-t.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-cairo-surface-t.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-cairo-t.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-drawing.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-Error-handling.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-fonts.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-FreeType-Fonts.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-Image-Surfaces.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-Paths.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-PDF-Surfaces.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-PNG-Support.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-PostScript-Surfaces.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-Quartz-(CGFont)-Fonts.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-Quartz-Surfaces.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-Recording-Surfaces.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-Regions.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-support.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-surfaces.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-SVG-Surfaces.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-text.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-Transformations.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-Types.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-User-Fonts.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-Version-Information.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-Win32-Fonts.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-Win32-Surfaces.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo-XLib-Surfaces.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo.devhelp"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\cairo.devhelp2"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\home.png"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\index-1.10.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\index-1.2.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\index-1.4.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\index-1.6.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\index-1.8.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\index-all.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\index.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\index.sgml"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\language-bindings.html"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\left.png"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\right.png"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\style.css"
  File "C:\gnustepdev\share\gtk-doc\html\cairo\up.png"
SectionEnd

Section "gnustep-cairo" SEC06
  SectionIn RO
  ; Files from gnustep-cairo
  SetOutPath "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle"
  File "C:\gnustepdev\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\libgnustep-cairo-023.dll"
  SetOutPath "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\Resources\English.lproj"
  File "C:\gnustepdev\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\Resources\English.lproj\nfontFaceNames.strings"
  SetOutPath "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\Resources"
  File "C:\gnustepdev\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\Resources\Info-gnustep.plist"
  SetOutPath "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\Resources\Swedish.lproj"
  File "C:\gnustepdev\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\Resources\Swedish.lproj\nfontFaceNames.strings"
  SetOutPath "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle"
  File "C:\gnustepdev\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\stamp.make"
SectionEnd


Section Uninstall
  ; Delete list for glib
  Delete "$INSTDIR\bin\libgthread-2.0-0.dll"
  Delete "$INSTDIR\bin\libgobject-2.0-0.dll"
  Delete "$INSTDIR\bin\libgmodule-2.0-0.dll"
  Delete "$INSTDIR\bin\libglib-2.0-0.dll"
  Delete "$INSTDIR\bin\libgio-2.0-0.dll"
  Delete "$INSTDIR\bin\gspawn-win32-helper.exe"
  Delete "$INSTDIR\bin\gspawn-win32-helper-console.exe"

  ; Delete list for expat

  ; Delete list for freetype
  Delete "$INSTDIR\share\aclocal\freetype2.m4"
  Delete "$INSTDIR\lib\pkgconfig\freetype2.pc"
  Delete "$INSTDIR\lib\libfreetype.la"
  Delete "$INSTDIR\lib\libfreetype.dll.a"
  Delete "$INSTDIR\lib\libfreetype.a"
  Delete "$INSTDIR\include\ft2build.h"
  Delete "$INSTDIR\include\freetype2\freetype\ttunpat.h"
  Delete "$INSTDIR\include\freetype2\freetype\tttags.h"
  Delete "$INSTDIR\include\freetype2\freetype\tttables.h"
  Delete "$INSTDIR\include\freetype2\freetype\ttnameid.h"
  Delete "$INSTDIR\include\freetype2\freetype\t1tables.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftxf86.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftwinfnt.h"
  Delete "$INSTDIR\include\freetype2\freetype\fttypes.h"
  Delete "$INSTDIR\include\freetype2\freetype\fttrigon.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftsystem.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftsynth.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftstroke.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftsnames.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftsizes.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftrender.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftpfr.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftoutln.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftotval.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftmoderr.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftmodapi.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftmm.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftmac.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftlzw.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftlist.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftlcdfil.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftincrem.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftimage.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftgzip.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftgxval.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftglyph.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftgasp.h"
  Delete "$INSTDIR\include\freetype2\freetype\fterrors.h"
  Delete "$INSTDIR\include\freetype2\freetype\fterrdef.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftcid.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftchapters.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftcache.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftbzip2.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftbitmap.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftbdf.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftbbox.h"
  Delete "$INSTDIR\include\freetype2\freetype\ftadvanc.h"
  Delete "$INSTDIR\include\freetype2\freetype\freetype.h"
  Delete "$INSTDIR\include\freetype2\freetype\config\ftstdlib.h"
  Delete "$INSTDIR\include\freetype2\freetype\config\ftoption.h"
  Delete "$INSTDIR\include\freetype2\freetype\config\ftmodule.h"
  Delete "$INSTDIR\include\freetype2\freetype\config\ftheader.h"
  Delete "$INSTDIR\include\freetype2\freetype\config\ftconfig.h"
  Delete "$INSTDIR\bin\libfreetype-6.dll"
  Delete "$INSTDIR\bin\freetype-config"

  ; Delete list for fontconfig
  Delete "$INSTDIR\share\man\man1\fc-scan.1"
  Delete "$INSTDIR\share\man\man1\fc-query.1"
  Delete "$INSTDIR\share\man\man1\fc-pattern.1"
  Delete "$INSTDIR\share\man\man1\fc-match.1"
  Delete "$INSTDIR\share\man\man1\fc-list.1"
  Delete "$INSTDIR\share\man\man1\fc-cat.1"
  Delete "$INSTDIR\share\man\man1\fc-cache.1"
  Delete "$INSTDIR\lib\libfontconfig.la"
  Delete "$INSTDIR\lib\libfontconfig.dll.a"
  Delete "$INSTDIR\lib\libfontconfig.a"
  Delete "$INSTDIR\lib\fontconfig.def"
  Delete "$INSTDIR\include\fontconfig\fontconfig.h"
  Delete "$INSTDIR\include\fontconfig\fcprivate.h"
  Delete "$INSTDIR\include\fontconfig\fcfreetype.h"
  Delete "$INSTDIR\etc\fonts\conf.d\README"
  Delete "$INSTDIR\bin\libfontconfig-1.dll"
  Delete "$INSTDIR\bin\fc-scan.exe"
  Delete "$INSTDIR\bin\fc-query.exe"
  Delete "$INSTDIR\bin\fc-pattern.exe"
  Delete "$INSTDIR\bin\fc-match.exe"
  Delete "$INSTDIR\bin\fc-list.exe"
  Delete "$INSTDIR\bin\fc-cat.exe"
  Delete "$INSTDIR\bin\fc-cache.exe"

  ; Delete list for pixman
  Delete "$INSTDIR\lib\pkgconfig\pixman-1.pc"
  Delete "$INSTDIR\lib\libpixman-1.la"
  Delete "$INSTDIR\lib\libpixman-1.dll.a"
  Delete "$INSTDIR\lib\libpixman-1.a"
  Delete "$INSTDIR\include\pixman-1\pixman.h"
  Delete "$INSTDIR\include\pixman-1\pixman-version.h"
  Delete "$INSTDIR\bin\libpixman-1-0.dll"

  ; Delete list for cairo
  Delete "$INSTDIR\share\gtk-doc\html\cairo\up.png"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\style.css"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\right.png"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\left.png"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\language-bindings.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\index.sgml"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\index.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\index-all.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\index-1.8.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\index-1.6.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\index-1.4.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\index-1.2.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\index-1.10.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\home.png"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo.devhelp2"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo.devhelp"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-XLib-Surfaces.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-Win32-Surfaces.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-Win32-Fonts.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-Version-Information.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-User-Fonts.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-Types.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-Transformations.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-text.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-SVG-Surfaces.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-surfaces.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-support.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-Regions.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-Recording-Surfaces.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-Quartz-Surfaces.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-Quartz-(CGFont)-Fonts.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-PostScript-Surfaces.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-PNG-Support.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-PDF-Surfaces.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-Paths.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-Image-Surfaces.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-FreeType-Fonts.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-fonts.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-Error-handling.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-drawing.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-cairo-t.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-cairo-surface-t.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-cairo-scaled-font-t.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-cairo-pattern-t.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-cairo-matrix-t.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-cairo-font-options-t.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-cairo-font-face-t.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\cairo-cairo-device-t.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\bindings-surfaces.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\bindings-streams.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\bindings-return-values.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\bindings-patterns.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\bindings-path.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\bindings-overloading.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\bindings-memory.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\bindings-fonts.html"
  Delete "$INSTDIR\share\gtk-doc\html\cairo\bindings-errors.html"
  Delete "$INSTDIR\lib\pkgconfig\cairo.pc"
  Delete "$INSTDIR\lib\pkgconfig\cairo-win32.pc"
  Delete "$INSTDIR\lib\pkgconfig\cairo-win32-font.pc"
  Delete "$INSTDIR\lib\pkgconfig\cairo-svg.pc"
  Delete "$INSTDIR\lib\pkgconfig\cairo-ps.pc"
  Delete "$INSTDIR\lib\pkgconfig\cairo-png.pc"
  Delete "$INSTDIR\lib\pkgconfig\cairo-pdf.pc"
  Delete "$INSTDIR\lib\pkgconfig\cairo-ft.pc"
  Delete "$INSTDIR\lib\pkgconfig\cairo-fc.pc"
  Delete "$INSTDIR\lib\libcairo.la"
  Delete "$INSTDIR\lib\libcairo.dll.a"
  Delete "$INSTDIR\lib\libcairo.a"
  Delete "$INSTDIR\lib\libcairo-script-interpreter.la"
  Delete "$INSTDIR\lib\libcairo-script-interpreter.dll.a"
  Delete "$INSTDIR\lib\libcairo-script-interpreter.a"
  Delete "$INSTDIR\include\cairo\cairo.h"
  Delete "$INSTDIR\include\cairo\cairo-win32.h"
  Delete "$INSTDIR\include\cairo\cairo-version.h"
  Delete "$INSTDIR\include\cairo\cairo-svg.h"
  Delete "$INSTDIR\include\cairo\cairo-script-interpreter.h"
  Delete "$INSTDIR\include\cairo\cairo-ps.h"
  Delete "$INSTDIR\include\cairo\cairo-pdf.h"
  Delete "$INSTDIR\include\cairo\cairo-ft.h"
  Delete "$INSTDIR\include\cairo\cairo-features.h"
  Delete "$INSTDIR\include\cairo\cairo-deprecated.h"
  Delete "$INSTDIR\bin\libcairo-script-interpreter-2.dll"
  Delete "$INSTDIR\bin\libcairo-2.dll"

  ; Delete list for gnustep-cairo
  Delete "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\stamp.make"
  Delete "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\Resources\Swedish.lproj\nfontFaceNames.strings"
  Delete "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\Resources\Info-gnustep.plist"
  Delete "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\Resources\English.lproj\nfontFaceNames.strings"
  Delete "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\libgnustep-cairo-023.dll"


  ; rmdir list for gnustep-cairo
  RMDir "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\Resources\Swedish.lproj"
  RMDir "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\Resources\English.lproj"
  RMDir "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle\Resources"
  RMDir "$INSTDIR\GNUstep\System\Library\Bundles\libgnustep-cairo-023.bundle"

  ; rmdir list for cairo
  RMDir "$INSTDIR\share\gtk-doc\html\cairo"
  RMDir "$INSTDIR\share\gtk-doc\html"
  RMDir "$INSTDIR\share\gtk-doc"

  ; rmdir list for pixman
  RMDir "$INSTDIR\lib\pkgconfig"
  RMDir "$INSTDIR\include\pixman-1"

  ; rmdir list for fontconfig
  RMDir "$INSTDIR\share\man\man1"
  RMDir "$INSTDIR\include\fontconfig"
  RMDir "$INSTDIR\etc\fonts\conf.d"
  RMDir "$INSTDIR\etc\fonts"

  ; rmdir list for freetype
  RMDir "$INSTDIR\include\freetype2\freetype"
  RMDir "$INSTDIR\include\freetype2"

  ; rmdir list for expat
  ; rmdir list for glib

  Delete "$INSTDIR\gnustep-cairo-README.rtf"
  Delete "$INSTDIR\UninstallGNUstepCairo.exe"
  !insertmacro MUI_STARTMENU_GETFOLDER Application $ICONS_GROUP
  Delete "$SMPROGRAMS\$ICONS_GROUP\Uninstall\UninstallCairo.lnk"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} "glib 2.18.1"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC02} "freetype 2.3.7"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC03} "fontconfig 2.6.0"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC04} "pixman 0.13.2"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC05} "cairo 1.8.6"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC06} "GNUstep Cairo Backend Aug 2012"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section -AdditionalIcons
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Uninstall\UninstallCairo.lnk" "$INSTDIR\UninstallGNUstepCairo.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\UninstallGNUstepCairo.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\UninstallGNUstepCairo.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\m.ico"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"

SectionEnd
Function .onInstSuccess
  ; Activate the Cairo backend if desired
  ;
  ${If} $CAIRO_BACKEND = ${BST_CHECKED}
    Exec '"$INSTDIR\GNUstep\System\Tools\defaults.exe" write NSGlobalDomain GSBackend cairo'
  ${EndIf}
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

