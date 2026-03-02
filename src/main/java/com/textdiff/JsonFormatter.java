package com.textdiff;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSyntaxException;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;

/**
 * JSON格式化工具
 */
public class JsonFormatter {
    
    private static final Gson gson = new GsonBuilder()
            .setPrettyPrinting()
            .disableHtmlEscaping()
            .serializeSpecialFloatingPointValues()
            .create();
    
    /**
     * 判断字符串是否为有效的JSON
     */
    public static boolean isValidJson(String text) {
        if (text == null || text.trim().isEmpty()) {
            return false;
        }
        
        text = text.trim();
        // 检查是否以 { 或 [ 开头
        return text.startsWith("{") || text.startsWith("[");
    }
    
    /**
     * 格式化JSON字符串（保持原有顺序）
     * @param json JSON字符串
     * @return 格式化后的JSON字符串，如果不是有效JSON则返回原字符串
     */
    public static String formatJson(String json) {
        if (json == null || json.trim().isEmpty()) {
            return json;
        }
        
        if (!isValidJson(json)) {
            return json;
        }
        
        try {
            // 解析JSON以保持原始顺序
            JsonElement element = JsonParser.parseString(json);
            return gson.toJson(element);
        } catch (JsonSyntaxException e) {
            // 如果解析失败，返回原字符串
            return json;
        }
    }
}
