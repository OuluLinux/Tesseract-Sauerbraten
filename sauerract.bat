@ECHO OFF
setlocal

set "TESS_BIN=bin"

IF EXIST bin64\tesseract.exe (
    IF /I "%PROCESSOR_ARCHITECTURE%" == "amd64" (
        set TESS_BIN=bin64
    )
    IF /I "%PROCESSOR_ARCHITEW6432%" == "amd64" (
        set TESS_BIN=bin64
    )
)

set "ORIG_VCPKG_ROOT=%VCPKG_ROOT%"
set "VCPKG_ROOT="
IF DEFINED TESS_VCPKG_ROOT (
    IF EXIST "%TESS_VCPKG_ROOT%\installed" (
        set "VCPKG_ROOT=%TESS_VCPKG_ROOT%"
    )
)
IF NOT DEFINED VCPKG_ROOT (
    IF DEFINED ORIG_VCPKG_ROOT (
        IF EXIST "%ORIG_VCPKG_ROOT%\installed" (
            set "VCPKG_ROOT=%ORIG_VCPKG_ROOT%"
        )
    )
)
IF NOT DEFINED VCPKG_ROOT (
    IF EXIST "%USERPROFILE%\vcpkg\installed" (
        set "VCPKG_ROOT=%USERPROFILE%\vcpkg"
    ) ELSE IF EXIST "E:\active\sblo\Dev\vcpkg\installed" (
        set "VCPKG_ROOT=E:\active\sblo\Dev\vcpkg"
    )
)

set "VCPKG_BIN="
IF DEFINED VCPKG_ROOT (
    IF EXIST "%VCPKG_ROOT%\installed\x64-windows\bin" (
        set "VCPKG_BIN=%VCPKG_ROOT%\installed\x64-windows\bin"
    )
)
IF NOT DEFINED VCPKG_BIN (
    IF EXIST "%USERPROFILE%\vcpkg\installed\x64-windows\bin" (
        set "VCPKG_BIN=%USERPROFILE%\vcpkg\installed\x64-windows\bin"
    ) ELSE IF EXIST "E:\active\sblo\Dev\vcpkg\installed\x64-windows\bin" (
        set "VCPKG_BIN=E:\active\sblo\Dev\vcpkg\installed\x64-windows\bin"
    )
)
IF DEFINED VCPKG_BIN (
    set "PATH=%VCPKG_BIN%;%PATH%"
)
IF DEFINED VCPKG_ROOT (
    IF EXIST "%VCPKG_ROOT%\installed\x64-windows\debug\bin" (
        set "PATH=%VCPKG_ROOT%\installed\x64-windows\debug\bin;%PATH%"
    )
    IF EXIST "%VCPKG_ROOT%\installed\x64-windows-release\bin" (
        set "PATH=%VCPKG_ROOT%\installed\x64-windows-release\bin;%PATH%"
    )
)

IF NOT EXIST "%TESS_BIN%\tesseract.exe" (
    echo ERROR: "%TESS_BIN%\tesseract.exe" not found.
    exit /b 1
)

where /q SDL2.dll
IF ERRORLEVEL 1 (
    echo WARNING: SDL2.dll not found in PATH.
    IF DEFINED VCPKG_ROOT echo INFO: VCPKG_ROOT=%VCPKG_ROOT%
    IF DEFINED VCPKG_BIN echo INFO: VCPKG_BIN=%VCPKG_BIN%
)
where /q zlib1.dll
IF ERRORLEVEL 1 (
    echo WARNING: zlib1.dll not found in PATH.
)

"%TESS_BIN%\tesseract.exe" "-k%~dp0." "-u%USERPROFILE%\My Games\Sauerract" -glog.txt %*
set "TESS_EXIT=%ERRORLEVEL%"
IF NOT "%TESS_EXIT%"=="0" (
    echo ERROR: tesseract.exe exited with code %TESS_EXIT%.
    exit /b %TESS_EXIT%
)
exit /b 0
