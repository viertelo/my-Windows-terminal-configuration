# 🖥️ Windows Terminal 核心外观与高阶配置

本目录包含 Windows Terminal（终端顶层容器）的终极调优配置 [`settings.json`](settings.json)。提供统一的 **Catppuccin Mocha** 赛博朋克深色美学、无缝图标字体回退链、毛玻璃半透明视窗与多终端直觉分屏。

---

## 📁 目录内容

```text
Terminal/
├── settings.json          # Windows Terminal 核心配置文件（外观、配色、各 Shell Profile、按键绑定）
└── README.md              # 本说明文档
```

---

## ✨ 核心特性

1. 🎨 **统一色彩美学 (Catppuccin Mocha)**：
   - 包含精心校准的 16 色 ANSI 配色、背景色 (`#1E1E2E`) 与前景色 (`#CDD6F4`)；
   - 所有终端 Profile（PowerShell、NuShell、CMD、Git Bash、MSYS2）全局统一继承此色彩方案。
2. 🔤 **智能字体多层回退链 (Nerd Font Fallback)**：
   - 默认主字体：`JetBrainsMono NFM`（带符号增强版）；
   - 备用字体链：`Cascadia Mono NF` ➔ `FiraCode Nerd Font` ➔ `Consolas`；
   - 彻底解决 Git 分支、文件管理器图标、OS 标识出现方块或空白问号的问题。
3. 🪟 **亚克力毛玻璃视觉质感**：
   - 启用全局 `acrylic` 高级半透明特效，背景不透明度精调为 `88%`（`0.88`），兼顾透亮视效与高对比度阅读舒适性。
4. ⚡ **一站式多终端环境集成**：
   - 原生支持 **PowerShell 7 (pwsh)**、**NuShell (nu)**、**CMD (cmd.exe)**、**Git Bash** 与 **MSYS2 (clang64)**。
   - 所有终端默认起始目录均安全映射至 `%USERPROFILE%`，杜绝打开落入 `System32` 的困扰。

---

## ⚙️ 本地安装与部署

### 1. 对应本地文件路径
Windows 商店版 Windows Terminal 默认配置文件位于：
```text
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```
（便携版或免安装版位于对应主程序的同级或解压目录）。

### 2. 手动部署方式
在 PowerShell 中运行：
```powershell
$wtDest = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Copy-Item .\Terminal\settings.json $wtDest -Force
```

---

## ⌨️ 常用全局快捷键速查

| 快捷键 | 功能 | 说明 |
| :--- | :--- | :--- |
| `Ctrl+Shift+P` | 调出命令面板 (Command Palette) | 快速检索所有终端动作与命令 |
| `Alt+Shift+D` | 自动拆分窗格 (垂直/水平自适应) | 沿最长边分割出一个全新的当前 Shell 窗格 |
| `Alt+Shift+-` | 水平拆分窗格 | 将当前视窗上下分为两个窗格 |
| `Alt+Shift++` | 垂直拆分窗格 | 将当前视窗左右分为两个窗格 |
| `Alt+方向键` | 在分屏窗格间切换焦点 | 快速穿梭于多个分屏之间 |
| `Alt+Shift+方向键` | 调整当前窗格尺寸 | 像素级微调窗格宽度或高度 |
| `Ctrl+Shift+W` | 关闭当前活动窗格 | 窗格退出或关闭 |
| `Ctrl+Shift+T` | 打开新标签页 | 启动默认 Profile（PowerShell 7） |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | 切换标签页 | 向前 / 向后快速轮转标签 |
| `Ctrl+Shift+F` | 视窗全局搜索 | 在终端历史滚动输出中高亮搜索文本 |
