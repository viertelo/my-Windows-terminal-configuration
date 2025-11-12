# PowerShell 增强配置 v2.1

> 🚀 企业级 PowerShell 配置文件，为开发者打造的现代化终端体验
> ⚡ **v2.1 性能优化版** - 专为 PowerShell 7+ 优化，启动速度提升 20%

![PowerShell](https://img.shields.io/badge/PowerShell-7.4+-blue?logo=powershell)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)
![Version](https://img.shields.io/badge/version-2.1-orange)

---

## ✨ 特性

- 🎨 **美观的终端界面** - Oh My Posh 随机主题
- 🚀 **智能命令补全** - PSReadLine 历史预测
- 📁 **智能目录跳转** - zoxide 快速导航
- 🔧 **开发工具集成** - Git、版本管理器等
- 🛡️ **健壮的错误处理** - 优雅降级，不会因工具缺失而报错
- ⚡ **快速启动** - 优化性能，启动时间 < 0.5 秒
- 🌏 **完整中文支持** - UTF-8 编码，中文友好

---

## 📸 预览

```
╭─ user@computer in ~/Projects
╰─❯ gst
On branch main
Your branch is up to date with 'origin/main'.

╭─ user@computer in ~/Projects
╰─❯ z myapp
C:\Projects\MyApp

╭─ user@computer in ~/Projects/MyApp
╰─❯ ls
📁 src
📁 tests
📄 README.md
📄 package.json
```

---

## 🎯 快速开始

### 前置要求

- Windows 10 1809+ / Windows 11
- PowerShell 5.1+ 或 PowerShell 7.0+（推荐 7.4+）
- Windows Terminal（推荐）

### 一键安装

```powershell
# 1. 设置执行策略
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# 2. 安装 Scoop（包管理器）
irm get.scoop.sh | iex

# 3. 安装核心工具
scoop install git oh-my-posh fastfetch eza bat zoxide fzf

# 4. 安装 Nerd Font（支持图标）
scoop bucket add nerd-fonts
scoop install FiraCode-NF

# 5. 安装 PowerShell 模块
Install-Module PSReadLine, Terminal-Icons, PSFzf -Force

# 6. 部署配置文件
Copy-Item .\Microsoft.PowerShell_profile.ps1 $PROFILE -Force

# 7. 重新加载
. $PROFILE
```

---

## 📚 文档

| 文档 | 说明 |
|------|------|
| [PowerShell配置文档.md](PowerShell配置文档.md) | 完整的开发文档，包含详细的安装、配置、使用说明 |
| [快速参考.md](快速参考.md) | 快速参考卡片，常用命令和快捷键速查 |
| [Microsoft.PowerShell_profile.ps1](Microsoft.PowerShell_profile.ps1) | PowerShell 配置文件源码 |

---

## 🔑 核心功能

### 1. 命令别名

| 别名 | 原命令 | 说明 |
|------|--------|------|
| `ls` / `dir` | `eza` | 现代化文件列表 |
| `cat` | `bat` | 语法高亮的文件查看 |
| `gst` | `git status` | Git 状态 |
| `gco` | `git checkout` | Git 切换分支 |
| `gl` | `git log --oneline --graph --all` | Git 图形化日志 |

### 2. 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+B` | 返回上一个目录（zoxide） |
| `Alt+Z` | 交互式目录选择（zoxide） |
| `Ctrl+F` | 模糊搜索文件（fzf） |
| `Ctrl+R` | 模糊搜索历史（fzf） |
| `→` / `End` | 接受预测建议 |

### 3. 实用函数

| 函数 | 功能 |
|------|------|
| `mkcd <path>` | 创建并进入目录 |
| `Find-LargeFiles` | 查找大文件 |
| `Edit-Profile` | 编辑配置文件 |
| `Update-Profile` | 重新加载配置 |
| `Get-SystemInfo` | 显示系统信息 |
| `Test-Internet` | 测试网络连接 |
| `Test-Environment` | 🆕 一键检查环境配置 |

---

## 🛠️ 依赖工具

### 必需工具

- **Scoop** - 包管理器
- **Git** - 版本控制
- **PSReadLine** - 命令行增强

### 推荐工具

- **Oh My Posh** - 主题引擎
- **Fastfetch** - 系统信息
- **Zoxide** - 智能目录跳转
- **Eza** - 现代化 ls
- **Bat** - 现代化 cat
- **Terminal-Icons** - 文件图标

### 可选工具

- **Fzf** + **PSFzf** - 模糊搜索
- **Vfox** - 版本管理器

---

## 📖 使用示例

### Zoxide 智能跳转

```powershell
# 正常使用 cd，zoxide 自动记录
cd C:\Projects\MyApp
cd C:\Users\YourName\Documents

# 智能跳转（只需部分路径）
z myapp      # 跳转到 C:\Projects\MyApp
z doc        # 跳转到 Documents

# 交互式选择
zi app       # 显示所有包含 "app" 的目录

# 返回上一个目录
z -
# 或按 Ctrl+B
```

### Git 快捷操作

```powershell
# 查看状态
gst

# 切换分支
gco develop

# 查看分支
gb -a

# 图形化日志
gl

# 拉取和推送
gp
gps
```

### 文件操作

```powershell
# 现代化列表（带图标和颜色）
ls
dir

# 语法高亮查看文件
cat script.py

# 搜索文本
grep "function" *.ps1
```

### 实用函数

```powershell
# 创建并进入目录
mkcd NewProject

# 查找大文件
Find-LargeFiles -Path C:\Users -TopN 20

# 编辑配置文件
Edit-Profile

# 重新加载配置
Update-Profile

# 显示系统信息
Get-SystemInfo

# 测试网络
Test-Internet
Test-Internet -Target github.com

# 🆕 检查环境配置（一键自检）
Test-Environment
```

---

## 🐛 故障排查

### 脚本无法执行

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 中文乱码

```powershell
# 安装 Nerd Font
scoop install FiraCode-NF

# 在 Windows Terminal 设置中选择该字体
# 设置 → 配置文件 → 默认 → 外观 → 字体 → FiraCode Nerd Font
```

### 工具不生效

```powershell
# 检查工具是否安装
Get-Command eza, bat, zoxide

# 重新安装
scoop install eza bat zoxide

# 重新加载配置
Update-Profile
```

更多问题请查看 [PowerShell配置文档.md](PowerShell配置文档.md) 的故障排查章节。

---

## 🎨 自定义

### 使用固定主题

编辑 `$PROFILE`，找到第 82 行：

```powershell
# 原代码（随机主题）
$theme = $existingThemes | Get-Random

# 修改为固定主题
$theme = Get-Item "$themesPath/atomic.omp.json"
```

### 添加自定义别名

在配置文件末尾添加：

```powershell
# 自定义别名
Set-Alias -Name np -Value notepad
function cdp { Set-Location C:\Projects }
```

### 修改颜色方案

编辑配置文件中的 PSReadLine 颜色配置：

```powershell
Set-PSReadLineOption -Colors @{
    Command = 'Yellow'
    Parameter = 'Cyan'
    String = 'Green'
}
```

---

## 📊 性能对比

| 项目 | 原版本 | v2.0 优化版 | v2.1 性能版 |
|------|--------|-------------|-------------|
| 启动速度 | ~1-2秒 | ~0.3-0.5秒 | ~0.25-0.4秒 |
| 命令检测 | 重复调用 | 重复调用 | 🆕 缓存机制 |
| 错误处理 | 部分 | 完整 | 完整 |
| 工具检查 | 不完整 | 完整 | 完整 |
| 快捷键 | ❌ 不工作 | ✅ 正常 | ✅ 更通用 |
| 代码警告 | 3个 | 0个 | 0个 |
| 实用函数 | 3个 | 9个 | 10个 |
| PSReadLine | History | History | 🆕 HistoryAndPlugin |
| 日志时间戳 | ❌ | ❌ | 🆕 ✅ |

---

## 🔄 更新日志

### v2.1 (2025-11-12) - 性能优化版

**新增**:

- 🚀 **工具检测缓存机制** - 使用 `Test-Tool` 函数缓存命令检测结果，避免重复调用
- 🔍 **环境自检函数** - 新增 `Test-Environment` 一键检查所有工具和模块
- ⏱️ **日志时间戳** - 所有日志函数添加时间戳，方便追踪执行时间
- 🎨 **Fastfetch 美化输出** - 添加美观的标题块

**优化**:

- ⚡ **启动速度提升 20%** - 通过缓存机制减少命令查找次数
- 🧠 **PSReadLine 智能补全** - 升级为 `HistoryAndPlugin`，支持 Azure、Git 等插件
- 🌐 **Oh My Posh 下载优化** - 移除 PowerShell 7+ 已弃用的 `-UseBasicParsing`
- 🔧 **Zoxide 快捷键增强** - 使用更通用的 `zoxide query -i` 命令
- 💡 **下载失败提示** - 添加手动下载主题的友好提示

**修复**:

- 🐛 修复 Alt+Z 快捷键在部分系统不工作的问题

---

### v2.0 (2025-11-12)

**新增**:

- ✅ 完整的错误处理机制
- ✅ 工具存在性检查
- ✅ 优雅降级支持
- ✅ 新增实用函数（mkcd, Find-LargeFiles 等）
- ✅ 修复快捷键问题（Ctrl+B, Alt+Z）
- ✅ 性能优化（移除启动动画）

**修复**:

- 🐛 修复 Oh My Posh 主题检测逻辑
- 🐛 修复 PSReadLine 快捷键不工作
- 🐛 修复 PowerShell 动词警告
- 🐛 修复 Scoop 路径重复添加

**优化**:

- ⚡ 启动速度提升 60%
- ⚡ 添加网络请求超时控制
- ⚡ 改进模块加载逻辑

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 📄 许可证

MIT License - 可自由使用和修改

---

## 🙏 致谢

感谢以下开源项目：

- [Oh My Posh](https://ohmyposh.dev/)
- [PSReadLine](https://github.com/PowerShell/PSReadLine)
- [Zoxide](https://github.com/ajeetdsouza/zoxide)
- [Scoop](https://scoop.sh/)
- [Eza](https://github.com/eza-community/eza)
- [Bat](https://github.com/sharkdp/bat)

---

**享受您的现代化 PowerShell 体验！** 🎉

