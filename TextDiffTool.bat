@echo off
REM 文本比对工具启动脚本
cd /d "%~dp0"
java -jar target\text-diff-tool-1.0.0.jar --gui
