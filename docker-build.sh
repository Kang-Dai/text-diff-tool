#!/bin/bash
# 使用Docker云端打包脚本

echo "======================================"
echo "Docker云端打包"
echo "======================================"
echo

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "[ERROR] Docker not found"
    echo "请先安装Docker"
    exit 1
fi

# 构建Docker镜像
echo "[1/3] 构建Docker镜像..."
docker build -f Dockerfile.build -t textdiff-builder .
if [ $? -eq 0 ]; then
    echo "[OK] Docker image built"
else
    echo "[ERROR] Docker build failed"
    exit 1
fi

# 运行容器打包
echo "[2/3] 运行容器打包..."
mkdir -p dist/portable
docker run --rm -v "$(pwd)/dist:/output" textdiff-builder bash -c "
    cp -r /app/dist/portable/* /output/
"

if [ $? -eq 0 ]; then
    echo "[OK] Files copied from container"
else
    echo "[ERROR] Container execution failed"
    exit 1
fi

# 打包产物
echo "[3/3] 打包产物..."
cd dist/portable
tar -czf ../../text-diff-tool-portable.tar.gz *
cd ../..

echo "[OK] Package created"

echo
echo "======================================"
echo "打包完成！"
echo "======================================"
echo
echo "输出文件："
ls -lh text-diff-tool-portable.tar.gz
echo
echo "内容："
ls -lh dist/portable/
echo
