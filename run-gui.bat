@echo off
echo ========================================
echo 文本比对工具 - 启动GUI界面
echo ========================================
echo.

REM 检查JAR文件是否存在
if not exist "target\text-diff-tool-1.0.0.jar" (
    echo JAR文件不存在，正在编译...
    call mvn clean package -DskipTests
    if errorlevel 1 (
        echo 编译失败！
        pause
        exit /b 1
    )
)

echo 启动GUI界面...
echo.

java -jar target\text-diff-tool-1.0.0.jar --gui

if errorlevel 1 (
    echo.
    echo 启动GUI失败！
    pause
    exit /b 1
)

pause
