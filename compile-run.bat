@echo off
echo 正在编译项目...
echo.

REM 编译项目（跳过测试）
call mvn clean compile

if errorlevel 1 (
    echo 编译失败！
    pause
    exit /b 1
)

echo.
echo 编译成功！
echo.
echo 正在启动GUI界面...
echo.

REM 启动GUI
java -cp "target/classes;%USERPROFILE%\.m2\repository\com\google\code\gson\gson\2.10.1\gson-2.10.1.jar;%USERPROFILE%\.m2\repository\org\openjfx\javafx-controls\21.0.1\javafx-controls-21.0.1.jar;%USERPROFILE%\.m2\repository\org\openjfx\javafx-base\21.0.1\javafx-base-21.0.1.jar;%USERPROFILE%\.m2\repository\org\openjfx\javafx-graphics\21.0.1\javafx-graphics-21.0.1.jar" com.textdiff.TextDiffGUI

pause
