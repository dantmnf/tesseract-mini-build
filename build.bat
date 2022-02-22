setlocal EnableDelayedExpansion

for /f "delims=" %%i in ('"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -latest -format value -property installationPath') do set vsdir=%%i

call "!vsdir!\VC\Auxiliary\Build\vcvars64.bat"
echo on

rem cd /d "%~dp0"
set rootdir=%~dp0
set prefix=%rootdir%\sysprefix
mkdir %prefix%
mkdir %prefix%\lib
if not defined tessprefix set tessprefix=%rootdir%\out
set LIB=%LIB%;%PREFIX%\lib
mkdir build
pushd build



echo * Building zlib
call :download https://www.zlib.net/zlib-1.2.11.tar.gz
tar xf zlib-1.2.11.tar.gz
mkdir zlib
pushd zlib
rem zlib cmake need -DBUILD_SHARED_LIBS=ON to generate correct library name (zlib1)
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX:PATH="%prefix%" "%rootdir%\build\zlib-1.2.11"  || goto err
ninja install || goto err
copy /y "%prefix%\lib\zlibstatic.lib" "%prefix%\lib\zlib.lib"
popd



echo * Building libpng
call :download http://prdownloads.sourceforge.net/libpng/libpng-1.6.37.tar.gz
tar xf libpng-1.6.37.tar.gz
mkdir libpng
pushd libpng
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DPNG_SHARED=OFF -DCMAKE_INSTALL_PREFIX:PATH="%prefix%" "%rootdir%\build\libpng-1.6.37" || goto err
ninja install || goto err
popd

goto notiff
echo * Building libtiff
call :download https://download.osgeo.org/libtiff/tiff-4.3.0.tar.gz
tar xf tiff-4.3.0.tar.gz
mkdir libtiff
pushd libtiff
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX:PATH="%prefix%" "%rootdir%\build\tiff-4.3.0" || goto err
ninja install || goto err
popd
:notiff

echo * Building leptonica
call :download https://github.com/DanBloomberg/leptonica/releases/download/1.82.0/leptonica-1.82.0.tar.gz
tar xf leptonica-1.82.0.tar.gz
mkdir leptonica
pushd leptonica
cmake -GNinja -DSW_BUILD=OFF -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX:PATH="%prefix%" "%rootdir%\build\leptonica-1.82.0" || goto err
ninja install || goto err
popd


echo * Building tesseract
call :download https://github.com/tesseract-ocr/tesseract/archive/refs/tags/5.0.1.tar.gz
tar xf 5.0.1.tar.gz
mkdir tesseract
pushd tesseract
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCPPAN_BUILD=OFF -DGRAPHICS_DISABLED=ON -DAUTO_OPTIMIZE=ON -DUSE_AVX2=ON -DUSE_AVX=ON -DUSE_FMA=ON -DUSE_SSE4_1=ON -DBUILD_TRAINING_TOOLS=OFF -DSW_BUILD=OFF -DCMAKE_SYSTEM_PREFIX_PATH:PATH="%prefix%" -DCMAKE_INSTALL_PREFIX:PATH="%tessprefix%" "%rootdir%\build\tesseract-5.0.1" || goto err
ninja install || goto err
echo * Purging cmake files
rmdir /s /q "%tessprefix%\lib\cmake"
popd

popd

exit /b

:err
pause

popd

exit /b


rem functions

:download
	@echo off
	setlocal EnableDelayedExpansion
	set url=%~1
	set destfile=%~2
	if "!destfile!"=="" for %%i in ("!url!") do set destfile=%%~nxi
	if exist "!destfile!" set extra_args= -z "!destfile!" 
	echo downloading !url! to !destfile!
	curl -L -o "!destfile!" !extra_args! "!url!"
	exit /b
