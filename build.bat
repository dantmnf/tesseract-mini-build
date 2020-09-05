@echo off

setlocal

rem cd /d "%~dp0"
set rootdir="%~dp0"
set prefix=%CD%\sysprefix
mkdir %prefix%
mkdir %prefix%\lib
if not defined tessprefix set tessprefix=%CD%\out
set LIB=%LIB%;%PREFIX%\lib
mkdir build


echo * Building zlib
mkdir build\zlib
pushd build\zlib
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX:PATH="%prefix%" "%rootdir%\zlib"  || exit /b
ninja install || exit /b
copy /y "%prefix%\lib\zlibstatic.lib" "%prefix%\lib\zlib.lib"
popd

echo * Building libpng
mkdir build\libpng
pushd build\libpng
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DPNG_SHARED=OFF -DCMAKE_INSTALL_PREFIX:PATH="%prefix%" "%rootdir%\libpng" || exit /b
ninja install || exit /b
popd

echo * Building libtiff
mkdir build\libtiff
pushd build\libtiff
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX:PATH="%prefix%" "%rootdir%\libtiff" || exit /b
ninja install || exit /b
popd


echo * Building leptonica
mkdir build\leptonica
pushd build\leptonica
cmake -GNinja -DSW_BUILD=OFF -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX:PATH="%prefix%" "%rootdir%\leptonica" || exit /b
ninja install || exit /b
popd


echo * Building tesseract
mkdir build\tesseract
pushd build\tesseract
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCPPAN_BUILD=OFF -DGRAPHICS_DISABLED=ON -DAUTO_OPTIMIZE=ON -DUSE_AVX2=ON -DUSE_AVX=ON -DUSE_FMA=ON -DUSE_SSE4_1=ON -DBUILD_TRAINING_TOOLS=OFF -DSW_BUILD=OFF -DCMAKE_SYSTEM_PREFIX_PATH:PATH="%prefix%" -DCMAKE_INSTALL_PREFIX:PATH="%tessprefix%" "%rootdir%\tesseract" || exit /b
ninja install || exit /b
echo * Purging cmake files
rmdir /s /q "%tessprefix%\cmake"
popd

