#!/bin/bash
# Cloud Studio 云端打包脚本

echo "======================================"
echo "Text Diff Tool - Cloud Studio Build"
echo "======================================"
echo

# 检查Java环境
echo "[1/5] 检查Java环境..."
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    echo "[OK] $JAVA_VERSION"
else
    echo "[ERROR] Java not found"
    exit 1
fi

# 检查Maven
echo "[2/5] 检查Maven..."
if command -v mvn &> /dev/null; then
    MVN_VERSION=$(mvn -version | head -n 1)
    echo "[OK] $MVN_VERSION"
else
    echo "[ERROR] Maven not found"
    echo "请先安装Maven: sudo apt-get install maven"
    exit 1
fi

# 构建JAR
echo "[3/5] 构建JAR文件..."
mvn clean package -DskipTests
if [ $? -eq 0 ]; then
    echo "[OK] JAR build completed"
else
    echo "[ERROR] JAR build failed"
    exit 1
fi

# 创建便携版
echo "[4/5] 创建便携版..."
mkdir -p dist/portable
cp target/text-diff-tool-1.0.0.jar dist/portable/
cp TextDiffTool.bat dist/portable/
cp "给用户的说明.txt" dist/portable/说明.txt

# 创建README
cat > dist/portable/README.txt << 'EOF'
文本比对工具 v1.0.0
=====================================

云端构建版本 - Cloud Studio

快速开始：
1. 安装Java 8+
2. 运行: TextDiffTool.bat
3. 或: java -jar text-diff-tool-1.0.0.jar --gui

功能特点：
- 文本比对
- JSON格式化
- 差异高亮
- 图形界面

祝您使用愉快！
EOF

echo "[OK] Portable version created"

# 打包
echo "[5/5] 打包输出..."
cd dist/portable
tar -czf ../../text-diff-tool-portable.tar.gz *
cd ../..
echo "[OK] Package created: text-diff-tool-portable.tar.gz"

echo
echo "======================================"
echo "构建完成！"
echo "======================================"
echo
echo "输出文件："
ls -lh text-diff-tool-portable.tar.gz dist/portable/*
echo
echo "下载地址："
echo "从Cloud Studio下载这些文件"
echo

# 显示文件路径
echo "文件路径："
realpath text-diff-tool-portable.tar.gz
realpath dist/portable/text-diff-tool-1.0.0.jar
