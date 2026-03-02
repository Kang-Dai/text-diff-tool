@echo off
echo ========================================
echo 文本比对工具 - 启动GUI界面
echo ========================================
echo.

REM 检查target目录下是否有JAR文件
if not exist "target\text-diff-tool-1.0.0.jar" (
    echo JAR文件不存在，正在打包...
    call mvn clean package -DskipTests
    if errorlevel 1 (
        echo 打包失败！
        pause
        exit /b 1
    )
    echo 打包完成。
    echo.
)

echo 启动GUI界面...
echo.

REM 使用JavaFX模块启动GUI
java --module-path "%USERPROFILE%\.m2\repository\org\openjfx\javafx-controls\11.0.2" ^
     --add-modules javafx.controls ^
     -cp "target\text-diff-tool-1.0.0.jar;%USERPROFILE%\.m2\repository\com\google\code\gson\gson\2.8.9\gson-2.8.9.jar" ^
     com.textdiff.TextDiffGUI --gui

if errorlevel 1 (
    echo.
    echo 启动失败！尝试另一种方式...
    echo.
    
    REM 尝试不使用模块化方式
    java -cp "target\text-diff-tool-1.0.0.jar;%USERPROFILE%\.m2\repository\com\google\code\gson\gson\2.8.9\gson-2.8.9.jar;%USERPROFILE%\.m2\repository\org\openjfx\javafx-controls\11.0.2\javafx-controls-11.0.2-win.jar;%USERPROFILE%\.m2\repository\org\openjfx\javafx-base\11.0.2\javafx-base-11.0.2-win.jar;%USERPROFILE%\.m2\repository\org\openjfx\javafx-graphics\11.0.2\javafx-graphics-11.0.2-win.jar" com.textdiff.TextDiffGUI
    
    if errorlevel 1 (
        echo.
        echo 启动GUI失败！
        echo.
        echo 请检查：
        echo 1. Java版本是否为8或更高
        echo 2. Maven依赖是否正确下载
        pause
        exit /b 1
    )
)

pause
