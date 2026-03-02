package com.textdiff;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

/**
 * 文本比对工具主程序
 * 
 * 使用方法:
 * java -jar text-diff-tool.jar <file1> <file2> [--no-json-format]
 * 
 * 参数:
 * file1 - 第一个文件路径或文本内容
 * file2 - 第二个文件路径或文本内容
 * --no-json-format - 禁用自动JSON格式化（默认启用）
 * 
 * 如果参数以 "--" 开头，则视为文本内容而非文件路径
 */
public class TextDiffTool {
    
    public static void main(String[] args) {
        // 检查是否启动GUI
        if (args.length > 0 && (args[0].equals("--gui") || args[0].equals("-gui"))) {
            TextDiffGUI.main(args);
            return;
        }
        
        if (args.length == 0) {
            printUsage();
            System.exit(1);
        }
        
        try {
            boolean autoFormatJson = true;
            int fileArgIndex = 0;
            
            // 检查是否有 --no-json-format 参数
            for (String arg : args) {
                if (arg.equals("--no-json-format")) {
                    autoFormatJson = false;
                    fileArgIndex++;
                }
            }
            
            if (args.length - fileArgIndex < 2) {
                System.err.println("错误: 需要提供两个文件或文本内容");
                printUsage();
                System.exit(1);
            }
            
            String arg1 = args[fileArgIndex];
            String arg2 = args[fileArgIndex + 1];
            
            // 判断是文件路径还是文本内容
            String text1 = getContent(arg1);
            String text2 = getContent(arg2);
            
            System.out.println("开始比对...");
            System.out.println("JSON自动格式化: " + (autoFormatJson ? "启用" : "禁用"));
            System.out.println();
            
            // 执行比对
            List<TextDiff.DiffItem> diffItems = TextDiff.diff(text1, text2, autoFormatJson);
            
            // 输出结果
            String result = TextDiff.formatDiff(diffItems);
            System.out.println(result);
            
            // 根据差异数量设置退出码
            int exitCode = 0;
            for (TextDiff.DiffItem item : diffItems) {
                if (item.type != TextDiff.DiffType.SAME) {
                    exitCode = 1;
                    break;
                }
            }
            
            System.exit(exitCode);
            
        } catch (Exception e) {
            System.err.println("错误: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
    
    /**
     * 获取内容（从文件或直接使用文本）
     */
    private static String getContent(String input) throws IOException {
        if (input.startsWith("--")) {
            // 视为文本内容
            return input.substring(2);
        } else {
            // 视为文件路径
            return new String(Files.readAllBytes(Paths.get(input)));
        }
    }
    
    /**
     * 打印使用说明
     */
    private static void printUsage() {
        System.out.println("文本比对工具 v1.0.0");
        System.out.println();
        System.out.println("使用方法:");
        System.out.println("  java -jar text-diff-tool.jar <file1> <file2> [--no-json-format]");
        System.out.println("  java -jar text-diff-tool.jar --text1 --text2 [--no-json-format]");
        System.out.println();
        System.out.println("参数:");
        System.out.println("  file1, file2       - 文件路径");
        System.out.println("  --text1, --text2   - 直接提供的文本内容");
        System.out.println("  --no-json-format  - 禁用自动JSON格式化");
        System.out.println();
        System.out.println("示例:");
        System.out.println("  # 比对两个文件");
        System.out.println("  java -jar target/text-diff-tool-1.0.0.jar file1.txt file2.txt");
        System.out.println();
        System.out.println("  # 比对两个JSON文件（自动格式化）");
        System.out.println("  java -jar target/text-diff-tool-1.0.0.jar test1.json test2.json");
        System.out.println();
        System.out.println("  # 比对两段文本");
        System.out.println("  java -jar target/text-diff-tool-1.0.0.jar --\"Hello World\" --\"Hello Java\"");
        System.out.println();
        System.out.println("  # 禁用JSON格式化");
        System.out.println("  java -jar target/text-diff-tool-1.0.0.jar file1.txt file2.txt --no-json-format");
    }
}
