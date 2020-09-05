@echo off

rem cd /d "%~dp0"
set rootdir="%~dp0"
mkdir prefix
mkdir prefix\lib
set prefix=%CD%\prefix
set tessprefix=%CD%\out
set LIB=%LIB%;%PREFIX%\lib
mkdir build


echo "* Building zlib"
mkdir zlib
pushd zlib
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX:PATH="%prefix%" "%rootdir%\zlib"
ninja install
copy /y "%prefix%\lib\zlibstatic.lib" "%prefix%\lib\zlib.lib"
popd

echo "* Building libpng"
mkdir libpng
pushd libpng
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DPNG_SHARED=OFF -DCMAKE_INSTALL_PREFIX:PATH="%prefix%" "%rootdir%\libpng"
ninja install
popd

echo "* Building libtiff"
mkdir libtiff
pushd libtiff
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX:PATH="%prefix%" "%rootdir%\libtiff"
ninja install
popd


echo "* Building leptonica"
mkdir leptonica
pushd leptonica
cmake -GNinja -DSW_BUILD=OFF -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX:PATH="%prefix%" "%rootdir%\leptonica"
ninja install
popd


echo "* Building tesseract"
mkdir tesseract
pushd tesseract
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCPPAN_BUILD=OFF -DGRAPHICS_DISABLED=ON -DAUTO_OPTIMIZE=ON -DUSE_AVX2=ON -DUSE_AVX=ON -DUSE_FMA=ON -DUSE_SSE4_1=ON -DBUILD_TRAINING_TOOLS=OFF -DSW_BUILD=OFF -CMAKE_SYSTEM_PREFIX_PATH:PATH="%prefix%" -DCMAKE_INSTALL_PREFIX:PATH="%tessprefix%" "%rootdir%\tesseract"
ninja install
popd

