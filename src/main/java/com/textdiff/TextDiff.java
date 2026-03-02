package com.textdiff;

import java.util.ArrayList;
import java.util.List;

/**
 * 文本比对核心类
 */
public class TextDiff {
    
    /**
     * 差异类型
     */
    public enum DiffType {
        SAME,       // 相同
        ADDED,      // 新增
        DELETED,    // 删除
        MODIFIED    // 修改
    }
    
    /**
     * 差异项
     */
    public static class DiffItem {
        public final DiffType type;
        public final String content;
        public final int leftLine;
        public final int rightLine;
        
        public DiffItem(DiffType type, String content, int leftLine, int rightLine) {
            this.type = type;
            this.content = content;
            this.leftLine = leftLine;
            this.rightLine = rightLine;
        }
        
        @Override
        public String toString() {
            String prefix;
            switch (type) {
                case SAME: prefix = "  "; break;
                case ADDED: prefix = "+ "; break;
                case DELETED: prefix = "- "; break;
                case MODIFIED: prefix = "~ "; break;
                default: prefix = "  ";
            }
            return prefix + content;
        }
    }
    
    /**
     * 计算两段文本的差异
     * @param leftText 左侧文本
     * @param rightText 右侧文本
     * @param autoFormatJson 是否自动格式化JSON
     * @return 差异列表
     */
    public static List<DiffItem> diff(String leftText, String rightText, boolean autoFormatJson) {
        // 自动格式化JSON
        if (autoFormatJson) {
            leftText = JsonFormatter.formatJson(leftText);
            rightText = JsonFormatter.formatJson(rightText);
        }
        
        String[] leftLines = leftText.split("\\r?\\n");
        String[] rightLines = rightText.split("\\r?\\n");
        
        return computeDiff(leftLines, rightLines);
    }
    
    /**
     * 使用最长公共子序列(LCS)算法计算差异
     */
    private static List<DiffItem> computeDiff(String[] leftLines, String[] rightLines) {
        int m = leftLines.length;
        int n = rightLines.length;
        
        // 构建LCS矩阵
        int[][] lcs = new int[m + 1][n + 1];
        
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (leftLines[i - 1].equals(rightLines[j - 1])) {
                    lcs[i][j] = lcs[i - 1][j - 1] + 1;
                } else {
                    lcs[i][j] = Math.max(lcs[i - 1][j], lcs[i][j - 1]);
                }
            }
        }
        
        // 使用迭代方式回溯生成差异（保证顺序正确）
        List<DiffItem> diffItems = new ArrayList<>();
        int i = m, j = n;
        
        // 先反向收集，最后再反转
        while (i > 0 || j > 0) {
            if (i > 0 && j > 0 && leftLines[i - 1].equals(rightLines[j - 1])) {
                diffItems.add(new DiffItem(DiffType.SAME, leftLines[i - 1], i, j));
                i--;
                j--;
            } else if (j > 0 && (i == 0 || lcs[i][j - 1] >= lcs[i - 1][j])) {
                diffItems.add(new DiffItem(DiffType.ADDED, rightLines[j - 1], 0, j));
                j--;
            } else {
                diffItems.add(new DiffItem(DiffType.DELETED, leftLines[i - 1], i, 0));
                i--;
            }
        }
        
        // 反转列表，因为我们是从后往前收集的
        List<DiffItem> result = new ArrayList<>();
        for (int k = diffItems.size() - 1; k >= 0; k--) {
            result.add(diffItems.get(k));
        }
        
        return result;
    }
    
    /**
     * 格式化输出差异
     */
    public static String formatDiff(List<DiffItem> diffItems) {
        StringBuilder sb = new StringBuilder();

        // 添加ANSI颜色代码（在支持的终端中）
        String ANSI_RESET = "\u001B[0m";
        String ANSI_RED = "\u001B[31m";
        String ANSI_GREEN = "\u001B[32m";

        sb.append(repeatString("=", 80)).append("\n");
        sb.append("文本比对结果\n");
        sb.append(repeatString("=", 80)).append("\n\n");

        for (DiffItem item : diffItems) {
            if (item.type == DiffType.SAME) {
                sb.append(item.content).append("\n");
            } else if (item.type == DiffType.ADDED) {
                sb.append(ANSI_GREEN).append(item.content).append(ANSI_RESET).append("\n");
            } else if (item.type == DiffType.DELETED) {
                sb.append(ANSI_RED).append(item.content).append(ANSI_RESET).append("\n");
            }
        }

        sb.append("\n").append(repeatString("=", 80)).append("\n");
        sb.append("统计: ");
        sb.append("相同=").append(countByType(diffItems, DiffType.SAME));
        sb.append(", 新增=").append(countByType(diffItems, DiffType.ADDED));
        sb.append(", 删除=").append(countByType(diffItems, DiffType.DELETED));
        sb.append("\n");

        return sb.toString();
    }

    /**
     * Java 8兼容的字符串重复方法
     */
    private static String repeatString(String str, int count) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < count; i++) {
            sb.append(str);
        }
        return sb.toString();
    }
    
    /**
     * 统计指定类型的差异数量
     */
    private static int countByType(List<DiffItem> diffItems, DiffType type) {
        int count = 0;
        for (DiffItem item : diffItems) {
            if (item.type == type) {
                count++;
            }
        }
        return count;
    }
}
