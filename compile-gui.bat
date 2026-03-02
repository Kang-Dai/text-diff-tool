@echo off
echo ========================================
echo 文本比对工具 - 编译并启动GUI
echo ========================================
echo.

REM 清理旧的编译文件
echo [1/3] 清理旧的编译文件...
call mvn clean
if errorlevel 1 (
    echo 清理失败！
    pause
    exit /b 1
)
echo 清理完成。
echo.

REM 编译项目
echo [2/3] 编译项目...
call mvn compile
if errorlevel 1 (
    echo 编译失败！
    pause
    exit /b 1
)
echo 编译成功。
echo.

REM 启动GUI
echo [3/3] 启动GUI界面...
echo.
java -cp "target/classes;%USERPROFILE%\.m2\repository\com\google\code\gson\gson\2.8.9\gson-2.8.9.jar;%USERPROFILE%\.m2\repository\org\openjfx\javafx-controls\11.0.2\javafx-controls-11.0.2-win.jar;%USERPROFILE%\.m2\repository\org\openjfx\javafx-base\11.0.2\javafx-base-11.0.2-win.jar;%USERPROFILE%\.m2\repository\org\openjfx\javafx-graphics\11.0.2\javafx-graphics-11.0.2-win.jar" com.textdiff.TextDiffGUI

if errorlevel 1 (
    echo.
    echo 启动失败！
    echo.
    echo 可能的解决方案：
    echo 1. 确保已安装Java 8或更高版本
    echo 2. 检查Maven依赖是否正确下载
    pause
    exit /b 1
)

echo.
echo 程序已退出。
pause
