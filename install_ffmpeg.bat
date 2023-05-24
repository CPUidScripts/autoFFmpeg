@echo off
setlocal

REM Check if curl is installed
where curl >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing curl...
    REM Download the curl binary and install it
    curl -o curl.zip https://curl.se/windows/dl-7.80.0/curl-7.80.0-win64-mingw.zip
    7z x curl.zip -ocurl
    set PATH=%PATH%;%cd%\curl\curl-7.80.0-win64-mingw\bin
    echo curl has been installed.
)

REM Check if 7z is installed
where 7z >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing 7z...
    REM Download the 7z binary and install it
    curl -o 7z.zip https://www.7-zip.org/a/7z1900-extra.7z
    7z x 7z.zip -o7z
    set PATH=%PATH%;%cd%\7z
    echo 7z has been installed.
)

REM Specify the download URL and destination file path
set "ffmpegUrl=https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z"
set "ffmpegDestination=%~dp0dependencies\ffmpeg-git-full.7z"

REM Create the dependencies directory if it doesn't exist
if not exist "%~dp0dependencies" mkdir "%~dp0dependencies"

REM Download FFmpeg
echo Downloading FFmpeg...
curl -o "%ffmpegDestination%" "%ffmpegUrl%"

REM Check if the download was successful
if not exist "%ffmpegDestination%" (
    echo Failed to download FFmpeg.
    exit /b 1
)

REM Extract FFmpeg
echo Extracting FFmpeg...
7z x "%ffmpegDestination%" -o"%~dp0dependencies"

REM Check if the extraction was successful
if errorlevel 1 (
    echo Failed to extract FFmpeg.
    exit /b 1
)

echo FFmpeg has been downloaded and extracted successfully.

REM Check if the dependencies folder is already in the PATH
echo Checking if dependencies folder is in the PATH...
set "existingPath=%PATH%"
set "dependenciesPath=%~dp0dependencies"
set "dependenciesPath=%dependenciesPath:\=\\%"
echo %existingPath% | findstr /i /c:"%dependenciesPath%" >nul 2>nul
if %errorlevel% equ 0 (
    echo Dependencies folder is already in the PATH.
) else (
    REM Add the dependencies folder to the PATH
    echo Adding dependencies folder to the PATH...
    setx PATH "%existingPath%;%dependenciesPath%"
    echo Dependencies folder has been added to the PATH.
)

endlocal
