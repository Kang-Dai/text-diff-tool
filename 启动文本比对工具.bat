@echo off
REM 文本比对工具启动脚本（便携版）

cd /d "%~dp0"

REM 检查是否存在内置JRE
if exist "jre\bin\java.exe" (
    echo 使用内置JRE启动...
    start "" jre\bin\java.exe -jar text-diff-tool-1.0.0.jar --gui
    exit /b 0
)

REM 检查系统是否安装了Java
where java >nul 2>&1
if %errorlevel% equ 0 (
    echo 使用系统Java启动...
    start "" java -jar text-diff-tool-1.0.0.jar --gui
    exit /b 0
)

REM 未找到Java
echo ========================================
echo 错误：未找到Java环境
echo ========================================
echo.
echo 请选择以下方式之一：
echo.
echo 方式1（推荐）：
echo   从以下地址下载并安装Java 8或更高版本
echo   https://www.oracle.com/java/technologies/downloads/#java8
echo   安装完成后，双击此脚本即可启动
echo.
echo 方式2（无需安装）：
echo   下载便携版JRE并解压到当前目录，重命名为"jre"
echo   JRE下载地址: https://adoptium.net/
echo.
echo 按任意键退出...
pause >nul
