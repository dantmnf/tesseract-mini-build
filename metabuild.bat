@echo off

set root=%~dp0
set base=%CD%
setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

mkdir build-amd64
pushd build-amd64
set tessprefix=%base%\tesseract-amd64
call "%root%\build.bat"
popd
endlocal

setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars32.bat"
mkdir build-x86
pushd build-x86
set tessprefix=%base%\tesseract-x86
call "%root%\build.bat"
popd
endlocal


mkdir runtimes\win-x64\native
mkdir runtimes\win-x86\native
xcopy "%base%\tesseract-amd64\bin" runtimes\win-x64\native
xcopy "%base%\tesseract-x86\bin" runtimes\win-x86\native
copy /y "%root%\tesseract-mini-bin.nuspec" .
nuget pack tesseract-mini-bin.nuspec

