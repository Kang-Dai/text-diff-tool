package com.textdiff;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;
import javafx.stage.Stage;

import java.util.List;

/**
 * 文本比对工具GUI界面
 */
public class TextDiffGUI extends Application {
    
    private TextArea leftTextArea;
    private TextArea rightTextArea;
    private CheckBox autoFormatJsonCheck;
    private Label statsLabel;
    private VBox leftBox;
    private VBox rightBox;
    
    @Override
    public void start(Stage primaryStage) {
        primaryStage.setTitle("文本比对工具 v1.0.0");
        
        // 创建主面板
        BorderPane root = new BorderPane();
        root.setPadding(new Insets(15));
        
        // 创建顶部工具栏
        ToolBar toolBar = createToolBar();
        root.setTop(toolBar);
        
        // 创建输入区域
        HBox inputArea = createInputArea();
        root.setCenter(inputArea);
        
        // 设置场景
        Scene scene = new Scene(root, 1200, 800);
        
        primaryStage.setScene(scene);
        primaryStage.show();
    }
    
    /**
     * 创建工具栏
     */
    private ToolBar createToolBar() {
        ToolBar toolBar = new ToolBar();
        
        // 自动格式化JSON选项
        autoFormatJsonCheck = new CheckBox("自动格式化JSON");
        autoFormatJsonCheck.setSelected(true);
        
        // 清空按钮
        Button clearButton = new Button("清空");
        clearButton.setOnAction(e -> clearAll());
        clearButton.setStyle("-fx-background-color: #f44336; -fx-text-fill: white;");
        
        // 对比按钮
        Button compareButton = new Button("开始对比");
        compareButton.setOnAction(e -> compareTexts());
        compareButton.setStyle("-fx-background-color: #4CAF50; -fx-text-fill: white; -fx-font-weight: bold; -fx-font-size: 14px;");
        compareButton.setMinWidth(120);
        
        // 图例
        HBox legend = createLegend();
        
        // 统计标签
        statsLabel = new Label("统计: 未开始");
        statsLabel.setStyle("-fx-font-size: 12px; -fx-text-fill: #666;");
        
        toolBar.getItems().addAll(
            new Separator(),
            autoFormatJsonCheck,
            new Separator(),
            clearButton,
            new Separator(),
            compareButton,
            new Separator(),
            legend,
            new Separator(),
            statsLabel
        );
        
        toolBar.setStyle("-fx-background-color: #f5f5f5; -fx-border-color: #ddd; -fx-border-width: 0 0 1 0;");
        
        return toolBar;
    }
    
    /**
     * 创建图例
     */
    private HBox createLegend() {
        HBox legend = new HBox(15);
        legend.setAlignment(Pos.CENTER_LEFT);
        
        Label sameLabel = createLegendLabel("相同", "#ffffff");
        Label addedLabel = createLegendLabel("新增", "#c8e6c9");
        Label deletedLabel = createLegendLabel("删除", "#ffcdd2");
        
        legend.getChildren().addAll(sameLabel, addedLabel, deletedLabel);
        
        return legend;
    }
    
    private Label createLegendLabel(String text, String color) {
        Label label = new Label(text);
        label.setStyle("-fx-background-color: " + color + "; -fx-background-radius: 4; -fx-padding: 4 8 4 8; -fx-border-color: #ddd; -fx-border-width: 1;");
        return label;
    }
    
    /**
     * 创建输入区域
     */
    private HBox createInputArea() {
        HBox hbox = new HBox(10);
        hbox.setPadding(new Insets(10, 0, 10, 0));
        
        // 左侧文本区域
        leftBox = createTextPane("左侧文本 / 文件1", true);
        leftTextArea = (TextArea) leftBox.getUserData();
        
        // 右侧文本区域
        rightBox = createTextPane("右侧文本 / 文件2", false);
        rightTextArea = (TextArea) rightBox.getUserData();
        
        // 按钮区域
        VBox buttonBox = createButtonBox();
        
        HBox.setHgrow(leftBox, Priority.ALWAYS);
        HBox.setHgrow(rightBox, Priority.ALWAYS);
        
        hbox.getChildren().addAll(leftBox, buttonBox, rightBox);
        
        return hbox;
    }
    
    /**
     * 创建文本面板
     */
    private VBox createTextPane(String title, boolean isLeft) {
        VBox vbox = new VBox(5);
        
        Label titleLabel = new Label(title);
        titleLabel.setStyle("-fx-font-weight: bold; -fx-font-size: 13px;");
        
        TextArea textArea = new TextArea();
        textArea.setWrapText(true);
        textArea.setStyle("-fx-font-family: 'Consolas', 'Monaco', monospace; -fx-font-size: 13px;");
        
        VBox.setVgrow(textArea, Priority.ALWAYS);
        
        vbox.getChildren().addAll(titleLabel, textArea);
        vbox.setUserData(textArea);
        
        return vbox;
    }
    
    /**
     * 创建按钮区域
     */
    private VBox createButtonBox() {
        VBox vbox = new VBox(15);
        vbox.setAlignment(Pos.CENTER);
        vbox.setPadding(new Insets(150, 10, 0, 10));
        
        Button leftToRightBtn = new Button("→");
        leftToRightBtn.setOnAction(e -> {
            rightTextArea.setText(leftTextArea.getText());
        });
        leftToRightBtn.setStyle("-fx-background-color: #2196F3; -fx-text-fill: white; -fx-font-size: 20px;");
        leftToRightBtn.setMinSize(50, 50);
        
        Button rightToLeftBtn = new Button("←");
        rightToLeftBtn.setOnAction(e -> {
            leftTextArea.setText(rightTextArea.getText());
        });
        rightToLeftBtn.setStyle("-fx-background-color: #2196F3; -fx-text-fill: white; -fx-font-size: 20px;");
        rightToLeftBtn.setMinSize(50, 50);
        
        vbox.getChildren().addAll(leftToRightBtn, rightToLeftBtn);
        
        return vbox;
    }
    
    /**
     * 执行文本对比
     */
    private void compareTexts() {
        String leftText = leftTextArea.getText();
        String rightText = rightTextArea.getText();
        
        if (leftText.isEmpty() && rightText.isEmpty()) {
            showAlert("提示", "请输入要对比的文本内容");
            return;
        }
        
        try {
            boolean autoFormatJson = autoFormatJsonCheck.isSelected();
            List<TextDiff.DiffItem> diffItems = TextDiff.diff(leftText, rightText, autoFormatJson);
            
            // 更新统计信息
            int sameCount = 0;
            int addedCount = 0;
            int deletedCount = 0;
            
            for (TextDiff.DiffItem item : diffItems) {
                switch (item.type) {
                    case SAME: sameCount++; break;
                    case ADDED: addedCount++; break;
                    case DELETED: deletedCount++; break;
                }
            }
            
            statsLabel.setText(String.format("统计: 相同=%d | 新增=%d | 删除=%d", sameCount, addedCount, deletedCount));
            
            // 应用高亮样式
            applyHighlightStyles(diffItems);
            
        } catch (Exception e) {
            showAlert("错误", "对比过程中发生错误: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 应用高亮样式（使用VBox+Label，支持高亮，并通过右键菜单支持复制）
     */
    private void applyHighlightStyles(List<TextDiff.DiffItem> diffItems) {
        // 创建ScrollPane
        ScrollPane leftScroll = new ScrollPane();
        ScrollPane rightScroll = new ScrollPane();
        
        VBox leftContent = new VBox();
        VBox rightContent = new VBox();
        
        leftScroll.setContent(leftContent);
        rightScroll.setContent(rightContent);
        
        leftScroll.setFitToWidth(true);
        rightScroll.setFitToWidth(true);
        leftScroll.setStyle("-fx-background-color: white;");
        rightScroll.setStyle("-fx-background-color: white;");
        
        // 按照原始顺序添加差异行
        for (TextDiff.DiffItem item : diffItems) {
            String[] lines = item.content.split("\n", -1);
            
            switch (item.type) {
                case SAME:
                    for (String line : lines) {
                        Label leftLabel = createLabel(line, "#ffffff", false);
                        Label rightLabel = createLabel(line, "#ffffff", false);
                        leftContent.getChildren().add(leftLabel);
                        rightContent.getChildren().add(rightLabel);
                    }
                    break;
                    
                case ADDED:
                    for (String line : lines) {
                        // 左侧显示空行
                        Label leftLabel = createLabel("", "#f5f5f5", false);
                        // 右侧显示绿色背景
                        Label rightLabel = createLabel(line, "#c8e6c9", true);
                        leftContent.getChildren().add(leftLabel);
                        rightContent.getChildren().add(rightLabel);
                    }
                    break;
                    
                case DELETED:
                    for (String line : lines) {
                        // 左侧显示红色背景
                        Label leftLabel = createLabel(line, "#ffcdd2", true);
                        // 右侧显示空行
                        Label rightLabel = createLabel("", "#f5f5f5", false);
                        leftContent.getChildren().add(leftLabel);
                        rightContent.getChildren().add(rightLabel);
                    }
                    break;
            }
        }
        
        // 添加右键复制菜单
        addCopyMenu(leftContent);
        addCopyMenu(rightContent);
        
        // 同步滚动
        ScrollPane finalLeftScroll = leftScroll;
        ScrollPane finalRightScroll = rightScroll;
        leftScroll.vvalueProperty().addListener((obs, oldVal, newVal) -> {
            finalRightScroll.setVvalue(newVal.doubleValue());
        });
        rightScroll.vvalueProperty().addListener((obs, oldVal, newVal) -> {
            finalLeftScroll.setVvalue(newVal.doubleValue());
        });
        
        // 替换原有TextArea
        leftBox.getChildren().set(1, leftScroll);
        rightBox.getChildren().set(1, rightScroll);
        
        // 更新引用
        leftTextArea = null;
        rightTextArea = null;
    }
    
    /**
     * 创建标签（支持选择和复制）
     */
    private Label createLabel(String text, String bgColor, boolean isDiff) {
        Label label = new Label(text.isEmpty() ? " " : text);
        label.setStyle("-fx-background-color: " + bgColor + "; " +
                       "-fx-font-family: 'Consolas', 'Monaco', monospace; " +
                       "-fx-font-size: 13px; " +
                       "-fx-padding: 2 8 2 8; " +
                       "-fx-border-color: #eee; " +
                       "-fx-border-width: 0 0 1 0; " +
                       (isDiff ? "-fx-font-weight: bold;" : "") +
                       "-fx-cursor: text;");
        
        // 支持文本选择
        label.setWrapText(true);
        
        return label;
    }
    
    /**
     * 添加复制菜单
     */
    private void addCopyMenu(VBox contentBox) {
        ContextMenu contextMenu = new ContextMenu();
        MenuItem copyItem = new MenuItem("复制所有内容");
        copyItem.setOnAction(e -> {
            StringBuilder sb = new StringBuilder();
            for (javafx.scene.Node node : contentBox.getChildren()) {
                if (node instanceof Label) {
                    Label label = (Label) node;
                    String text = label.getText();
                    if (!text.equals(" ")) {
                        sb.append(text).append("\n");
                    }
                }
            }
            
            // 复制到剪贴板
            javafx.scene.input.Clipboard clipboard = javafx.scene.input.Clipboard.getSystemClipboard();
            javafx.scene.input.ClipboardContent clipboardContent = new javafx.scene.input.ClipboardContent();
            clipboardContent.putString(sb.toString());
            clipboard.setContent(clipboardContent);
        });
        
        contextMenu.getItems().add(copyItem);
        
        // 为每个Label添加右键菜单
        contentBox.setOnContextMenuRequested(e -> {
            contextMenu.show(contentBox, e.getScreenX(), e.getScreenY());
        });
    }
    
    /**
     * 清空所有内容
     */
    private void clearAll() {
        // 清空统计
        statsLabel.setText("统计: 未开始");
        
        // 重新创建TextArea
        leftTextArea = new TextArea();
        rightTextArea = new TextArea();
        
        leftTextArea.setWrapText(true);
        rightTextArea.setWrapText(true);
        String style = "-fx-font-family: 'Consolas', 'Monaco', monospace; -fx-font-size: 13px;";
        leftTextArea.setStyle(style);
        rightTextArea.setStyle(style);
        
        VBox.setVgrow(leftTextArea, Priority.ALWAYS);
        VBox.setVgrow(rightTextArea, Priority.ALWAYS);
        
        leftBox.getChildren().set(1, leftTextArea);
        rightBox.getChildren().set(1, rightTextArea);
    }
    
    /**
     * 显示警告对话框
     */
    private void showAlert(String title, String message) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }
    
    public static void main(String[] args) {
        launch(args);
    }
}
