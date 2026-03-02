@echo off
REM 打包文本比对工具为可执行exe文件

echo ========================================
echo 文本比对工具 - 打包脚本
echo ========================================
echo.

REM 检查Maven是否可用
echo 检查Maven环境...
mvn -version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到Maven，请先安装Maven并配置环境变量
    pause
    exit /b 1
)
echo [OK] Maven环境正常
echo.

REM 检查Java是否可用
echo 检查Java环境...
java -version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到Java，请先安装Java 8或更高版本
    pause
    exit /b 1
)
echo [OK] Java环境正常
echo.

REM 清理旧的构建文件
echo [1/3] 清理旧的构建文件...
call mvn clean
if errorlevel 1 (
    echo [错误] 清理失败
    pause
    exit /b 1
)
echo [OK] 清理完成
echo.

REM 编译项目
echo [2/3] 编译项目并打包JAR...
call mvn package -DskipTests
if errorlevel 1 (
    echo [错误] 编译失败
    pause
    exit /b 1
)
echo [OK] 编译完成
echo.

REM 检查JAR文件是否生成
if not exist "target\text-diff-tool-1.0.0.jar" (
    echo [错误] JAR文件未生成，打包失败
    pause
    exit /b 1
)
echo [OK] JAR文件已生成
echo.

REM 尝试使用Launch4j打包exe
echo [3/3] 尝试生成EXE文件...
echo.

REM 检查Launch4j是否可用
set LAUNCH4J_CMD=""
if exist "C:\Program Files\Launch4j\launch4jc.exe" (
    set LAUNCH4J_CMD="C:\Program Files\Launch4j\launch4jc.exe"
) else if exist "C:\Program Files (x86)\Launch4j\launch4jc.exe" (
    set LAUNCH4J_CMD="C:\Program Files (x86)\Launch4j\launch4jc.exe"
)

if not "%LAUNCH4J_CMD%"=="" (
    echo 找到Launch4j，正在生成EXE文件...
    %LAUNCH4J_CMD% launch4j-config.xml
    if errorlevel 1 (
        echo [警告] EXE生成失败，请手动使用Launch4j生成
    ) else (
        echo [OK] EXE文件已生成
    )
) else (
    echo [提示] 未找到Launch4j
    echo.
    echo 您有以下选项：
    echo 1. 安装Launch4j: https://sourceforge.net/projects/launch4j/
    echo 2. 下载并解压后，将launch4jc.exe放在项目根目录下
    echo 3. 使用提供的JAR文件: target\text-diff-tool-1.0.0.jar
    echo.
)

echo.
echo ========================================
echo 打包完成！
echo ========================================
echo.
echo 生成的文件：
echo - JAR文件: target\text-diff-tool-1.0.0.jar
if exist "target\TextDiffTool.exe" (
    echo - EXE文件: target\TextDiffTool.exe
)
echo.
echo 使用方法：
echo 1. 双击EXE文件启动GUI（如果已生成）
echo 2. 或运行: java -jar target\text-diff-tool-1.0.0.jar --gui
echo.
pause
