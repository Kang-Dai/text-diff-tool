@echo off
REM 创建便携版包（包含JRE）

echo ========================================
echo 创建便携版安装包
echo ========================================
echo.

REM 先执行标准打包
call package.bat
if errorlevel 1 (
    pause
    exit /b 1
)

echo.
echo ========================================
echo 准备便携版文件
echo ========================================
echo.

REM 创建输出目录
if not exist "dist" mkdir dist

REM 复制EXE文件
if exist "target\TextDiffTool.exe" (
    copy "target\TextDiffTool.exe" "dist\TextDiffTool.exe" >nul
    echo [OK] EXE文件已复制
) else (
    copy "target\text-diff-tool-1.0.0.jar" "dist\text-diff-tool-1.0.0.jar" >nul
    echo [OK] JAR文件已复制
)

REM 检查是否需要包含JRE
echo.
echo 是否需要包含JRE（推荐）？
echo 包含JRE后，用户无需安装Java即可运行，但文件会较大（约100MB）
echo.
set /p INCLUDE_JRE="是否包含JRE？(y/n): "

if /i "%INCLUDE_JRE%"=="y" (
    echo.
    echo 请输入JRE路径（例如: C:\Program Files\Java\jre1.8.0_xxx）
    set /p JRE_PATH="JRE路径: "

    if exist "%JRE_PATH%" (
        xcopy "%JRE_PATH%" "dist\jre\" /E /I /H /Y >nul
        echo [OK] JRE已复制

        REM 更新launch4j配置以使用内置JRE
        powershell -Command "(Get-Content launch4j-config.xml) -replace '<bundledJre64Bit>false</bundledJre64Bit>', '<bundledJre64Bit>true</bundledJre64Bit>' -replace '<bundledJreAsFallback>false</bundledJreAsFallback>', '<bundledJreAsFallback>true</bundledJreAsFallback>' | Set-Content launch4j-portable.xml"

        REM 重新生成EXE
        if exist "dist\launch4jc.exe" (
            dist\launch4jc.exe launch4j-portable.xml
        )
    ) else (
        echo [错误] 指定的JRE路径不存在
    )
)

REM 创建启动脚本
echo @echo off > dist\启动文本比对工具.bat
echo cd /d "%%~dp0" >> dist\启动文本比对工具.bat
echo if exist "TextDiffTool.exe" ( >> dist\启动文本比对工具.bat
echo     start TextDiffTool.exe >> dist\启动文本比对工具.bat
echo ) else if exist "jre\bin\java.exe" ( >> dist\启动文本比对工具.bat
echo     jre\bin\java.exe -jar text-diff-tool-1.0.0.jar --gui >> dist\启动文本比对工具.bat
echo ) else ( >> dist\启动文本比对工具.bat
echo     echo 请先安装Java 8或更高版本 >> dist\启动文本比对工具.bat
echo     pause >> dist\启动文本比对工具.bat
echo ) >> dist\启动文本比对工具.bat

echo [OK] 启动脚本已创建

REM 创建README
echo 文本比对工具 v1.0.0 - 便携版 > dist\使用说明.txt
echo. >> dist\使用说明.txt
echo 使用方法: >> dist\使用说明.txt
echo 1. 双击 "启动文本比对工具.bat" 启动程序 >> dist\使用说明.txt
echo 2. 或直接双击 TextDiffTool.exe >> dist\使用说明.txt
echo. >> dist\使用说明.txt
echo 如果启动失败，请确保已安装Java 8或更高版本 >> dist\使用说明.txt
echo 下载地址: https://www.oracle.com/java/technologies/downloads/#java8 >> dist\使用说明.txt
echo. >> dist\使用说明.txt
echo 功能说明: >> dist\使用说明.txt
echo - 图形界面文本比对 >> dist\使用说明.txt
echo - 支持JSON自动格式化 >> dist\使用说明.txt
echo - 差异高亮显示（绿色新增，红色删除） >> dist\使用说明.txt
echo - 支持复制粘贴操作 >> dist\使用说明.txt
echo [OK] 使用说明已创建

echo.
echo ========================================
echo 便携版创建完成！
echo ========================================
echo.
echo 输出目录: dist\
echo 文件列表:
dir /b dist
echo.
pause
