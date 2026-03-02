@echo off
REM 创建独立可执行程序（包含JRE）
REM 需要Java 14+ (用于jpackage)

echo ========================================
echo 创建独立可执行程序
echo ========================================
echo.

REM 检查是否需要使用jpackage
echo [1/5] 检查Java版本...
for /f "tokens=3" %%i in ('java -version 2^>^&1 ^| findstr /i "version"') do set JAVA_VERSION=%%i
set JAVA_VERSION=%JAVA_VERSION:"=%
echo 当前Java版本: %JAVA_VERSION%

REM 提取主版本号
for /f "tokens=1,2 delims=." %%a in ("%JAVA_VERSION%") do (
    set MAJOR=%%a
    set MINOR=%%b
)

echo Java主版本: %MAJOR%.%MINOR%

if "%MAJOR%" geq "14" (
    echo [OK] 支持使用jpackage打包
    set USE_JPACKAGE=true
) else (
    echo [提示] Java版本低于14，不支持jpackage
    echo [提示] 将使用便携版方式（需要手动提供JRE）
    set USE_JPACKAGE=false
)
echo.

REM 确保JAR已编译
echo [2/5] 检查JAR文件...
if not exist "target\text-diff-tool-1.0.0.jar" (
    echo [提示] JAR文件不存在，开始编译...
    call mvn clean package -DskipTests
    if errorlevel 1 (
        echo [错误] 编译失败
        pause
        exit /b 1
    )
)
echo [OK] JAR文件已就绪
echo.

if "%USE_JPACKAGE%"=="true" (
    REM 使用jpackage打包
    echo [3/5] 使用jpackage创建安装包...

    REM 创建输出目录
    if not exist "dist" mkdir dist

    REM 使用jpackage创建EXE
    jpackage^
        --type exe^
        --input target^
        --dest dist^
        --name TextDiffTool^
        --main-jar text-diff-tool-1.0.0.jar^
        --main-class com.textdiff.TextDiffTool^
        --arguments "--gui"^
        --app-version 1.0.0^
        --vendor "TextDiffTool"^
        --description "文本比对工具 - 支持JSON格式化和差异高亮显示"^
        --win-menu^
        --win-shortcut

    if errorlevel 1 (
        echo [错误] jpackage打包失败
        pause
        exit /b 1
    )

    echo [OK] EXE安装包已生成
) else (
    REM 使用便携版方式
    echo [3/5] 使用便携版方式...

    REM 创建输出目录
    if not exist "dist" mkdir dist

    REM 复制JAR文件
    copy "target\text-diff-tool-1.0.0.jar" "dist\text-diff-tool-1.0.0.jar" >nul
    echo [OK] JAR文件已复制

    REM 询问JRE路径
    echo.
    echo 需要提供JRE路径以创建独立应用
    echo.
    echo 常见JRE路径示例:
    echo   C:\Program Files\Java\jre1.8.0_xxx
    echo   C:\Program Files\Java\jdk1.8.0_xxx\jre
    echo   或从: https://adoptium.net/ 下载JRE
    echo.

    set /p JRE_PATH="请输入JRE路径（或按回车跳过，只生成JAR版本）: "

    if defined JRE_PATH (
        if exist "%JRE_PATH%" (
            echo.
            echo [4/5] 复制JRE文件...
            xcopy "%JRE_PATH%" "dist\jre\" /E /I /H /Y /Q >nul
            echo [OK] JRE已复制
        ) else (
            echo [错误] 指定的JRE路径不存在: %JRE_PATH%
            echo 将只生成JAR版本
        )
    )
)

REM 创建启动脚本
echo [5/5] 创建启动脚本...
echo @echo off > dist\启动文本比对工具.bat
echo cd /d "%%~dp0" >> dist\启动文本比对工具.bat
if exist "dist\jre\bin\java.exe" (
    echo start "" jre\bin\java.exe -jar text-diff-tool-1.0.0.jar --gui >> dist\启动文本比对工具.bat
    echo   - 使用内置JRE >> dist\启动文本比对工具.bat
) else (
    echo start "" java -jar text-diff-tool-1.0.0.jar --gui >> dist\启动文本比对工具.bat
    echo   - 需要系统已安装Java 8+ >> dist\启动文本比对工具.bat
)
echo [OK] 启动脚本已创建

REM 创建用户说明
echo 文本比对工具 v1.0.0 > dist\使用说明.txt
echo. >> dist\使用说明.txt
echo 快速开始: >> dist\使用说明.txt
echo ============ >> dist\使用说明.txt
echo 双击 "启动文本比对工具.bat" 启动程序 >> dist\使用说明.txt
echo. >> dist\使用说明.txt
echo 功能特性: >> dist\使用说明.txt
echo - 图形界面文本比对 >> dist\使用说明.txt
echo - 支持JSON自动格式化 >> dist\使用说明.txt
echo - 差异高亮显示（绿色新增，红色删除） >> dist\使用说明.txt
echo - 支持复制粘贴操作 >> dist\使用说明.txt
echo [OK] 使用说明已创建

echo.
echo ========================================
echo 打包完成！
echo ========================================
echo.
echo 输出目录: dist\
echo.
echo 生成的文件:
dir /b dist
echo.
if exist "dist\jre" (
    echo 应用大小:
    echo dist 目录约:
    for /f "tokens=3" %%a in ('dir dist /s ^| find "个文件"') do echo %%a 字节
    echo.
    echo 这是一个独立应用，用户无需安装Java即可运行！
)
echo.
echo 分发方式:
echo 1. 将整个 dist 目录打包成ZIP
echo 2. 发送给其他用户
echo 3. 用户解压后双击 "启动文本比对工具.bat" 即可使用
echo.
pause
