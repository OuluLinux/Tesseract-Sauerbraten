@echo off
setlocal enabledelayedexpansion

:: requirements-windows.bat
:: Installs Sauerract dependencies using vcpkg

set VCPKG_EXE=

:: 1. Prefer ~/vcpkg
if exist "%USERPROFILE%\vcpkg\vcpkg.exe" (
    set "VCPKG_EXE=%USERPROFILE%\vcpkg\vcpkg.exe"
) else (
    :: 2. Check PATH
    where vcpkg >nul 2>nul
    if %ERRORLEVEL% equ 0 (
        for /f "delims=" %%i in ('where vcpkg') do (
            set "VCPKG_EXE=%%i"
            goto :found
        )
    )
)

:found
if "!VCPKG_EXE!"=="" (
    echo [ERROR] vcpkg not found in %USERPROFILE%\vcpkg or in your PATH.
    echo Please install vcpkg or ensure it is available.
    exit /b 1
)

echo [INFO] Found vcpkg at: !VCPKG_EXE!

:: Define the list of packages to install
:: Including features explicitly to avoid the missing JPEG issue encountered earlier
set "PACKAGES=sdl2:x64-windows"
set "PACKAGES=!PACKAGES! sdl2-image[core,libjpeg-turbo,libpng]:x64-windows"
set "PACKAGES=!PACKAGES! sdl2-mixer[core,vorbis,wavpack]:x64-windows"
set "PACKAGES=!PACKAGES! glew:x64-windows"
set "PACKAGES=!PACKAGES! zlib:x64-windows"
set "PACKAGES=!PACKAGES! libvorbis:x64-windows"
set "PACKAGES=!PACKAGES! dirent:x64-windows"
set "PACKAGES=!PACKAGES! rapidjson:x64-windows"

echo [INFO] Installing dependencies: !PACKAGES!
"!VCPKG_EXE!" install !PACKAGES! --recurse

if %ERRORLEVEL% equ 0 (
    echo [SUCCESS] All requirements installed successfully.
) else (
    echo [ERROR] vcpkg installation failed.
    exit /b %ERRORLEVEL%
)
