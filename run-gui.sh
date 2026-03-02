#!/bin/bash

echo "正在启动文本比对工具GUI界面..."
echo

# 编译项目
echo "编译项目..."
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo "编译失败！"
    exit 1
fi

echo
echo "启动GUI界面..."
echo

# 启动GUI
java --module-path "$PATH_TO_FX" --add-modules javafx.controls,javafx.fxml -jar target/text-diff-tool-1.0.0.jar --gui
