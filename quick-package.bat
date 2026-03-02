@echo off
chcp 65001 >nul
REM One-click portable packaging script

echo ========================================
echo Text Diff Tool - Quick Package
echo ========================================
echo.

REM Step 1: Clean and build
echo [Step 1] Building project...
call mvn clean package -DskipTests
if errorlevel 1 (
    echo [Error] Build failed
    pause
    exit /b 1
)
echo [OK] Build successful
echo.

REM Step 2: Create portable directory
echo [Step 2] Creating output directory...
if exist "dist\portable" rmdir /s /q "dist\portable"
mkdir dist\portable
echo [OK] Directory created
echo.

REM Step 3: Copy files
echo [Step 3] Copying program files...
copy "target\text-diff-tool-1.0.0.jar" "dist\portable\text-diff-tool-1.0.0.jar" >nul
copy "TextDiffTool.bat" "dist\portable\TextDiffTool.bat" >nul
copy "给用户的说明.txt" "dist\portable\说明.txt" >nul
echo [OK] Files copied
echo.

REM Step 4: Find and copy JRE
echo [Step 4] Finding JRE...
set JRE_FOUND=0

REM Search for JRE in common locations
for /r "C:\Program Files\Java" %%f in (java.exe) do (
    set JRE_FOUND=1
    set "JRE_DIR=%%~dpf.."
    goto :copy_jre
)

for /r "C:\Program Files (x86)\Java" %%f in (java.exe) do (
    set JRE_FOUND=1
    set "JRE_DIR=%%~dpf.."
    goto :copy_jre
)

:copy_jre
if %JRE_FOUND%==1 (
    echo [OK] Found JRE: %JRE_DIR%
    echo Copying JRE...
    xcopy "%JRE_DIR%" "dist\portable\jre\" /E /I /H /Y /Q >nul 2>&1
    if exist "dist\portable\jre\bin\java.exe" (
        echo [OK] JRE copied successfully
        set JRE_INCLUDED=1
    ) else (
        echo [Warning] JRE copy incomplete
        set JRE_INCLUDED=0
    )
) else (
    echo [Warning] JRE not found in system
    echo.
    echo You can manually download JRE from:
    echo https://adoptium.net/temurin/releases/?version=8
    echo.
    set JRE_INCLUDED=0
)

REM Step 5: Create launcher
echo [Step 5] Creating launcher...
echo @echo off > dist\portable\run.bat
echo cd /d "%%~dp0" >> dist\portable\run.bat
echo if exist "jre\bin\java.exe" ( >> dist\portable\run.bat
echo     start "" jre\bin\java.exe -jar text-diff-tool-1.0.0.jar --gui >> dist\portable\run.bat
echo ) else ( >> dist\portable\run.bat
echo     start "" java -jar text-diff-tool-1.0.0.jar --gui >> dist\portable\run.bat
echo ) >> dist\portable\run.bat
echo [OK] Launcher created
echo.

echo ========================================
echo Package Complete!
echo ========================================
echo.
if %JRE_INCLUDED%==1 (
    echo Type: Standalone (includes JRE)
    echo Users can run without Java installed!
) else (
    echo Type: Requires Java 8+
)
echo.
echo Output: dist\portable\
echo.
echo Files:
dir /b dist\portable
echo.

if exist "dist\portable\jre" (
    echo Total size:
    for /f "tokens=3" %%a in ('dir dist\portable /s ^| find "bytes" ^| find "File(s)"') do echo   %%a bytes
)
echo.

echo To distribute:
echo   1. Compress dist\portable\ to ZIP
echo   2. Send to users
echo   3. Users extract and double-click run.bat
echo.

pause
explorer dist\portable
