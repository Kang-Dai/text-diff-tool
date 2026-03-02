# 文本比对工具 (Text Diff Tool)

一个功能强大的文本比对工具，支持JSON自动格式化和差异高亮显示。

## 功能特性

- 📝 **文本比对** - 支持任意文本内容比对
- 🎨 **图形界面** - 直观的GUI操作界面
- ✨ **JSON格式化** - 自动检测并美化JSON格式
- 🎯 **差异高亮** - 绿色显示新增，红色显示删除
- 📋 **复制粘贴** - 支持选择和复制对比结果
- 🔄 **保持顺序** - JSON字段顺序保持不变
- 🔢 **数值保护** - 长数值不转换为科学计数法

## 快速开始

### 方式一：JAR文件（推荐）

1. 从 [Releases](../../releases) 下载最新的JAR文件
2. 运行命令：
   ```bash
   java -jar text-diff-tool-1.0.0.jar --gui
   ```

### 方式二：Windows安装程序

1. 从 [Releases](../../releases) 下载安装程序
2. 双击运行安装程序
3. 从桌面或开始菜单启动

### 方式三：本地编译

```bash
# 编译项目
mvn clean package

# 运行GUI
java -jar target/text-diff-tool-1.0.0.jar --gui

# 命令行比对
java -jar target/text-diff-tool-1.0.0.jar file1.txt file2.txt
```

## 使用说明

### 图形界面

1. 启动程序后，看到左右两个文本框
2. 在左右文本框中分别粘贴要比对的内容
3. 勾选"自动格式化JSON"可以美化JSON格式
4. 点击"开始对比"按钮
5. 查看底部对比结果：
   - 白色背景：相同的内容
   - 绿色背景：新增的内容
   - 红色背景：删除的内容

### 命令行

**比对文件：**
```bash
java -jar text-diff-tool-1.0.0.jar file1.txt file2.txt
```

**比对JSON文件（自动格式化）：**
```bash
java -jar text-diff-tool-1.0.0.jar test1.json test2.json
```

**直接比对文本内容：**
```bash
java -jar text-diff-tool-1.0.0.jar --"Hello World" --"Hello Java"
```

## 项目结构

```
src/main/java/com/textdiff/
├── TextDiffTool.java   # 主程序入口（支持CLI和GUI）
├── TextDiffGUI.java    # 图形界面
├── TextDiff.java       # 文本比对核心逻辑
└── JsonFormatter.java  # JSON格式化工具
```

## 依赖

- Java 8+
- Maven 3.6+
- Gson 2.8.9

## 开发

### 编译项目

```bash
mvn clean package
```

### 运行测试

```bash
mvn test
```

### 打包

```bash
# JAR文件
mvn package

# 便携版（包含JRE）
quick-package.bat

# Windows安装程序
create-installer.bat
```

## 云端构建

项目使用 [GitHub Actions](../../actions) 自动构建和发布。

- 推送代码自动触发构建
- 创建标签自动发布Release
- 从Actions或Releases下载构建产物

详见：[云端打包说明](云端打包说明.txt)

## 版本历史

### v1.0.0 (2026-03-02)

- ✨ 首次发布
- 🎨 图形界面
- 📝 文本比对功能
- ✨ JSON格式化
- 🎯 差异高亮显示

## 常见问题

**Q: GUI无法启动？**  
A: 确保使用Java 8或更高版本，检查命令 `java -version`

**Q: 编译失败？**  
A: 运行 `mvn clean package -DskipTests` 重新编译

**Q: 如何查看差异数量？**  
A: GUI界面底部会显示统计信息

**Q: 长数值变成科学计数法？**  
A: 程序会自动保持原始数值格式

**Q: JSON字段顺序改变了？**  
A: 程序会自动保持原始字段顺序

## 贡献

欢迎提交Issue和Pull Request！

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 致谢

- [Gson](https://github.com/google/gson) - JSON处理库
- [JavaFX](https://openjfx.io/) - GUI框架

---

**祝使用愉快！**
