; Inno Setup 安装脚本
; 需要先下载并安装 Inno Setup: https://jrsoftware.org/isdl.php

[Setup]
; 应用程序信息
AppName=文本比对工具
AppVersion=1.0.0
AppPublisher=TextDiffTool
AppPublisherURL=
AppSupportURL=
AppUpdatesURL=
DefaultDirName={commonpf}\TextDiffTool
DefaultGroupName=文本比对工具
AllowNoIcons=yes
OutputDir=dist
OutputBaseFilename=TextDiffTool-Setup
Compression=lzma
SolidCompression=yes
; 安装程序需要管理员权限
PrivilegesRequired=admin
; 自动创建桌面快捷方式
CreateAppDir=yes

; 文件和图标
[Icons]
Name: "{group}\文本比对工具"; Filename: "{app}\启动文本比对工具.bat"
Name: "{group}\卸载文本比对工具"; Filename: "{uninstallexe}"
Name: "{commondesktop}\文本比对工具"; Filename: "{app}\启动文本比对工具.bat"

; 安装文件
[Files]
Source: "target\text-diff-tool-1.0.0.jar"; DestDir: "{app}"; Flags: ignoreversion
Source: "启动文本比对工具.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "使用说明.txt"; DestDir: "{app}"; Flags: ignoreversion

; JRE 文件（如果有的话）
; Source: "jre\*"; DestDir: "{app}\jre"; Flags: ignoreversion recursesubdirs createallsubdirs

; 卸载时的文件
[UninstallDelete]
Type: filesandordirs; Name: "{app}"

; 安装前检查
[Code]
function IsJavaInstalled: Boolean;
var
  regVersion: Cardinal;
begin
  Result := RegQueryDWordValue(HKLM, 'SOFTWARE\JavaSoft\Java Runtime Environment', 'CurrentVersion', regVersion) or
            RegQueryDWordValue(HKLM, 'SOFTWARE\JavaSoft\Java Development Kit', 'CurrentVersion', regVersion);
end;

function InitializeSetup: Boolean;
begin
  Result := True;

  // 如果JRE目录存在，跳过检查
  if DirExists(ExpandConstant('{src}\jre')) then
  begin
    Result := True;
  end
  else
  begin
    // 检查是否已安装Java
    if not IsJavaInstalled then
    begin
      if MsgBox('检测到系统未安装Java。' + #13#10 +
                '本程序需要Java 8或更高版本。' + #13#10 +
                '是否继续安装（需要先安装Java）？',
                mbConfirmation, MB_YESNO) = IDNO then
      begin
        Result := False;
      end
      else
      begin
        ShellExec('open', 'https://www.oracle.com/java/technologies/downloads/#java8', '', '', SW_SHOW, ewNoWait, 0);
      end;
    end;
  end;
end;
