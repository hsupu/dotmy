<#
.LINK
https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes

.NOTES
## 默认快捷键

https://support.microsoft.com/en-us/windows/keyboard-shortcuts-in-windows-dcc61a57-8ff0-cffe-9796-cb9706c75eec

### Win10

常用的

- Win+E : Explorer
- Win+R : Run
- Win+L : Lock 锁屏
- Win+X : Execute? 开始按钮右键菜单
- Win+V : 系统自带的剪切板历史记录（在设置——系统——剪切板里开关）
- Win+Tab : 窗口切换叠层

也许有用的

- Win+O : Orientation 锁定设备朝向
- Win+S : Search 搜索框
- Win+P : Project 投影侧栏
- Win+A : Action Center 通知中心侧栏
- Win+D : Desktop 显示桌面
- Win+G : GameBar 游戏工具叠层
- Win+K : Connect 无线连接侧栏
- Win+Num : 打开主屏幕任务栏 1-9 项；Win+Shift+Num 强制打开新程序
- Win++ : 打开放大镜
- Win+, : 浮掠显示桌面
- Win+. Win+; : 显示 emoji 输入法

冷僻的

- Win+Q : Question? 同样打开了搜索
- Win+W : Whiteboard? Pen & Windows Ink Shortcuts
- Win+T : Taskbar 任务栏游走
- Win+Y : 在桌面和混合现实间切换输入源（如有）
- Win+U : 易用性中心；如无则重新打开 Windows 设置，焦点置于搜索框
- Win+I : 打开 Windows 设置，焦点置于搜索框
- Win+F : FeedbackHub 打开反馈程序
- Win+H : Hear? Dictation 听写
- Win+J : 聚焦于系统建议（如有）
- Win+Z : 全屏显示程序的可用命令（如有）
- Win+C : Cortana
- Win+B : 任务栏的通知栏游走
- Win+M : Minimize 所有窗口最小化；Win+Shift+M 恢复
- Win+Break : 打开 System Properties；实际是设置——关于
- Win+Home : 最小化所有其他窗口
- Win+Ctrl+Enter : 打开旁白（键盘阅读器）

无绑定

- Win+N
- Win+"-"

### Win11

- Win+A : Quick Settings
- Win+C : MS Teams
- Win+H : Voice Typing
- Win+K : Cast
- Win+N : Notification
- Win+W : Widget
- Win+Z : Snap Layout

## 禁用全局快捷键 Win+

该值是想要禁用的组合键们，如 `SA` 指禁用 Win+S Win+A。

然而，像 F G `;` 这类似乎并不由 explorer.exe 注册，因此这招不起作用。

- F 由 app "Feedback Hub" 控制，卸载即可
- G 由 app "Xbox Game Bar" 控制

PowerToys\Keyboard Manager 当 runas admin 时可以屏蔽它们
#>

$ErrorActionPreference = "Stop"
trap { throw $_ }

. (Join-Path $env:DOTMY "scripts/_lib/RegOp.ps1")

$WindowsBuildNumber = [System.Environment]::OSVersion.Version.Build
$isWin10 = $WindowsBuildNumber -lt 22000

if ($isWin10) {
    GetSetRegValue $hkcuWCVExplorerAdvanced "DisabledHotKeys" "BCHIJKMNOPQTUVWYZ``" "string"
}
else {
    GetSetRegValue $hkcuWCVExplorerAdvanced "DisabledHotKeys" "BCHIJKMNOPQTUVWY``" "string"
}
