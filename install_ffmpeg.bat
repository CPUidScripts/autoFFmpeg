@echo off
setlocal

REM Define variables
set "FFMPEG_URL=https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-2023-05-22-git-877ccaf776-full_build.7z"
set "FFMPEG_ARCHIVE=%CD%\dependencies\ffmpeg-git-full.7z"
set "SEVEN_ZIP_URL=https://www.7-zip.org/a/7z1900-extra.7z"
set "SEVEN_ZIP_ARCHIVE=%CD%\7z.zip"
set "SEVEN_ZIP_EXE=%CD%\7z\x64\7za.exe"
set "SEVEN_ZER_URL=https://www.7-zip.org/a/7zr.exe"
set "SEVEN_ZER_EXE=%CD%\7zr.exe"

if exist %SEVEN_ZER_EXE% (
echo skipping 7zr
) else (
echo downloading 7zr
powershell Invoke-WebRequest -Uri %SEVEN_ZER_URL% -OutFile %SEVEN_ZER_EXE%
)

if exist %SEVEN_ZIP_EXE% (
echo skipping 7za
) else (
echo Downloading 7za
powershell Invoke-WebRequest -Uri %SEVEN_ZIP_URL% -OutFile %SEVEN_ZIP_ARCHIVE%
)

%SEVEN_ZER_EXE% x "%SEVEN_ZIP_ARCHIVE%" -o"%CD%\7z"

REM Create the dependencies directory if it doesn't exist
if not exist "%CD%\dependencies" mkdir "%CD%\dependencies"

REM Download FFmpeg using curl
if exist %FFMPEG_ARCHIVE% (
echo skipping ffmpeg
) else (
echo Downloading FFmpeg...
powershell Invoke-WebRequest -Uri %FFMPEG_URL% -OutFile %FFMPEG_ARCHIVE%
)

REM Check if the download was successful
if not exist "%FFMPEG_ARCHIVE%" (
    echo Failed to download FFmpeg.
    exit /b 1
)

REM Extract FFmpeg
echo Extracting FFmpeg...
%SEVEN_ZIP_EXE% x "%FFMPEG_ARCHIVE%" -o"%CD%\dependencies"

REM Check if the extraction was successful
if errorlevel 1 (
    echo Failed to extract FFmpeg.
    exit /b 1
)

echo FFmpeg has been downloaded and extracted successfully.

REM Check if the dependencies folder is already in the PATH
echo Checking if dependencies folder is in the PATH...
set "existingPath=%PATH%"
set "dependenciesPath=C:\ffmpeg\ffmpeg-2023-05-22-git-877ccaf776-full_build\bin"
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
