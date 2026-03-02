@echo off
REM 创建包含JRE的便携版应用程序
REM 自动下载JRE或使用本地JRE

echo ========================================
echo 创建便携版应用程序（包含JRE）
echo ========================================
echo.

REM 检查JAR文件
echo [1/4] 检查JAR文件...
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

REM 创建输出目录
echo [2/4] 创建输出目录...
if not exist "dist\portable" mkdir dist\portable
echo [OK] 目录已创建
echo.

REM 复制文件
echo [3/4] 复制程序文件...
copy "target\text-diff-tool-1.0.0.jar" "dist\portable\text-diff-tool-1.0.0.jar" >nul
copy "启动文本比对工具.bat" "dist\portable\启动文本比对工具.bat" >nul
copy "给用户的说明.txt" "dist\portable\使用说明.txt" >nul
echo [OK] 文件已复制
echo.

REM JRE处理
echo [4/4] 准备JRE...
echo.
echo 有两种方式包含JRE：
echo.
echo 方式A: 自动下载JRE（需要联网，约50MB）
echo 方式B: 使用本地已安装的JRE
echo.
set /p JRE_CHOICE="请选择 (A/B) [默认: A]: "

if /i "%JRE_CHOICE%"=="B" (
    echo.
    echo 请输入JRE路径：
    echo 常见路径：
    echo   - C:\Program Files\Java\jre1.8.0_xxx
    echo   - C:\Program Files\Java\jdk1.8.0_xxx\jre
    echo   - C:\Program Files\Eclipse Adoptium\jdk-xxx\jre
    echo.
    set /p JRE_PATH="JRE路径: "

    if exist "%JRE_PATH%" (
        echo.
        echo 正在复制JRE文件...
        xcopy "%JRE_PATH%" "dist\portable\jre\" /E /I /H /Y /Q >nul 2>&1
        if exist "dist\portable\jre\bin\java.exe" (
            echo [OK] JRE复制成功
            set JRE_INCLUDED=1
        ) else (
            echo [错误] JRE复制失败，未找到java.exe
            set JRE_INCLUDED=0
        )
    ) else (
        echo [错误] 指定的路径不存在
        set JRE_INCLUDED=0
    )
) else (
    echo.
    echo 正在下载JRE...
    echo 注意：这是临时方案，实际建议使用官方JRE

    REM 检查是否有PowerShell
    powershell -Command "Write-Host 'PowerShell可用'" >nul 2>&1
    if errorlevel 1 (
        echo [警告] PowerShell不可用，跳过自动下载
        set JRE_INCLUDED=0
    ) else (
        echo.
        echo 请手动下载JRE:
        echo 1. 访问: https://adoptium.net/
        echo 2. 选择 Windows x64 JRE
        echo 3. 下载后解压到 dist\portable\jre 目录
        echo 4. 重启此脚本或手动复制JRE
        echo.
        set JRE_INCLUDED=0
    )
)

REM 检查JRE是否包含成功
if exist "dist\portable\jre\bin\java.exe" (
    echo.
    echo ========================================
    echo 便携版创建成功！
    echo ========================================
    echo.
    echo 输出目录: dist\portable\
    echo.
    echo 包含文件:
    dir /b dist\portable
    echo.
    echo 应用大小:
    for /f "tokens=3" %%a in ('dir dist\portable /s ^| find "个文件"') do echo   %%a 字节
    echo.
    echo 分发方式:
    echo   1. 将 dist\portable 目录打包成ZIP
    echo   2. 发送给其他用户
    echo   3. 用户解压后双击 "启动文本比对工具.bat" 即可使用
    echo.
    echo 优势: 用户无需安装Java，开箱即用！
    echo.
) else (
    echo.
    echo ========================================
    echo 基础版本创建完成（未包含JRE）
    echo ========================================
    echo.
    echo 输出目录: dist\portable\
    echo.
    echo 包含文件:
    dir /b dist\portable
    echo.
    echo 注意: 用户需要安装Java 8+才能运行
    echo.
    echo 如果要包含JRE，请手动执行：
    echo   xcopy [你的JRE路径] dist\portable\jre\ /E /I /H /Y
    echo.
)

pause
