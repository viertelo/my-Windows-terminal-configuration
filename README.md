# 🚀 Windows 终端完美配置方案

<div align="center">

![PowerShell](https://img.shields.io/badge/PowerShell-7.4+-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Windows Terminal](https://img.shields.io/badge/Windows%20Terminal-Latest-4D4D4D?style=for-the-badge&logo=windows-terminal&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/platform-Windows%2010/11-0078D6?style=for-the-badge&logo=windows&logoColor=white)

**为 Windows 开发者打造的现代化终端体验**

[快速开始](#-快速开始) • [功能特性](#-功能特性) • [文档](#-文档) • [截图预览](#-截图预览) • [常见问题](#-常见问题) • [📋 审计与优化报告](TERMINAL_AUDIT_REPORT.md)

</div>

---

## 📖 项目简介

这是一套完整的 Windows 终端配置方案，包含：

- 🎨 **PowerShell 高阶增强配置** - 工业级 PowerShell 配置文件，提供智能补全、超时容错、代码全文检索、退出自动联动等功能（详见 [审计报告](TERMINAL_AUDIT_REPORT.md)）
- 🖥️ **Windows Terminal 配置** - 精心调校的终端外观设置，包含 Catppuccin Mocha 主题、多层字体回退链、专业分屏快捷键等

让你的 Windows 终端体验媲美 macOS/Linux，甚至更好！

---

## ✨ 功能特性

### PowerShell 增强配置

- 🎨 **美观的终端界面** - 集成 Oh My Posh，支持随机主题切换
- 🚀 **智能命令补全** - PSReadLine 历史预测，自动建议命令
- 📁 **智能目录跳转** - Zoxide 快速导航，告别繁琐的 cd 命令
- 🔧 **开发工具集成** - Git 别名、版本管理器（vfox）等
- 🛡️ **健壮的错误处理** - 优雅降级，工具缺失不报错
- ⚡ **极速启动** - 性能优化，启动时间 < 0.5 秒
- 🌏 **完整中文支持** - UTF-8 编码，中文友好
- 📊 **系统信息展示** - Fastfetch 快速显示系统信息

### Windows Terminal 配置

- 🎨 **Catppuccin Mocha 主题** - 流行的暗色主题
- 🖼️ **背景图片支持** - 毛玻璃效果 + 自定义背景
- 🔤 **Nerd Font 字体** - JetBrainsMono，完美支持图标
- ⌨️ **优化的快捷键** - 符合直觉的操作体验
- 🪟 **分屏支持** - 快速分割窗格

---

## 🎯 快速开始

### 前置要求

- ✅ Windows 10 1809+ / Windows 11
- ✅ PowerShell 5.1+ 或 PowerShell 7.0+（**推荐 7.4+**）
- ✅ Windows Terminal（推荐）

### 一键安装脚本

```powershell
# 1. 设置执行策略（允许运行脚本）
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# 2. 安装 Scoop 包管理器
irm get.scoop.sh | iex

# 3. 添加必要的 bucket
scoop bucket add extras
scoop bucket add nerd-fonts

# 4. 安装核心工具
scoop install git oh-my-posh fastfetch eza bat zoxide fzf

# 5. 安装 Nerd Font（支持图标显示）
scoop install JetBrainsMono-NF

# 6. 安装 PowerShell 模块
Install-Module PSReadLine, Terminal-Icons, PSFzf -Force -SkipPublisherCheck

# 7. 克隆本仓库
git clone https://github.com/viertelo/my-Windows-terminal-configuration.git
cd my-Windows-terminal-configuration

# 8. 部署 PowerShell 配置文件
Copy-Item .\PowerShell-Enhanced-Profile\Microsoft.PowerShell_profile.ps1 $PROFILE -Force

# 9. 部署 Windows Terminal 配置（可选）
# 手动复制 Terminal\settings.json 到 Windows Terminal 配置目录
# 或在 Windows Terminal 设置中导入

# 10. 重新加载配置
. $PROFILE
```

### 手动安装

详细的手动安装步骤请参考 [PowerShell配置文档.md](PowerShell-Enhanced-Profile/PowerShell配置文档.md)

---

## 📸 截图预览

### PowerShell 终端效果

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

### 主要功能演示

**智能目录跳转（Zoxide）**
```powershell
z myapp      # 跳转到 C:\Projects\MyApp
z doc        # 跳转到 Documents
```

**现代化文件列表（Eza）**
```powershell
ls           # 彩色图标文件列表
ls -l        # 详细信息
ls -T        # 树状视图
```

**语法高亮查看文件（Bat）**
```powershell
cat config.json    # 自动语法高亮
```

---

## 🔑 核心功能

### 命令别名

| 别名 | 原命令 | 说明 |
|------|--------|------|
| `ls` / `dir` | `eza --icons` | 现代化文件列表，带图标 |
| `cat` | `bat` | 语法高亮的文件查看 |
| `z` | `zoxide` | 智能目录跳转 |
| `gst` | `git status` | Git 状态 |
| `gco` | `git checkout` | Git 切换分支 |
| `gl` | `git log --oneline --graph --all` | Git 图形化日志 |

### 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+B` | 返回上一个目录（zoxide） |
| `Alt+Z` | 交互式目录选择（zoxide） |
| `Ctrl+F` | 模糊搜索文件（fzf） |
| `Ctrl+R` | 模糊搜索历史命令（fzf） |
| `→` / `End` | 接受 PSReadLine 预测建议 |
| `Ctrl+Shift+F` | Windows Terminal 查找 |
| `Alt+Shift+D` | Windows Terminal 分屏 |

### 实用函数

| 函数 | 功能 |
|------|------|
| `mkcd <path>` | 创建并进入目录 |
| `Find-LargeFiles` | 查找大文件（>100MB） |
| `Edit-Profile` | 编辑 PowerShell 配置文件 |
| `Update-Profile` | 重新加载配置 |
| `Get-SystemInfo` | 显示系统信息（fastfetch） |
| `Test-Internet` | 测试网络连接 |
| `Test-Environment` | 🆕 一键检查环境配置 |

---

## 📚 文档

| 文档 | 说明 |
|------|------|
| [PowerShell配置文档.md](PowerShell-Enhanced-Profile/PowerShell配置文档.md) | 📖 完整的开发文档，包含详细的安装、配置、使用说明 |
| [快速参考.md](PowerShell-Enhanced-Profile/快速参考.md) | 📋 快速参考卡片，常用命令和快捷键速查 |
| [v2.1优化说明.md](PowerShell-Enhanced-Profile/v2.1优化说明.md) | 🚀 v2.1 版本性能优化详解 |
| [Microsoft.PowerShell_profile.ps1](PowerShell-Enhanced-Profile/Microsoft.PowerShell_profile.ps1) | 💻 PowerShell 配置文件源码 |

---

## 🛠️ 依赖工具

### 必需工具

- **Scoop** - Windows 包管理器
- **Git** - 版本控制系统
- **PSReadLine** - PowerShell 命令行增强模块

### 推荐工具（自动降级）

- **Oh My Posh** - 主题引擎
- **Fastfetch** - 系统信息展示
- **Zoxide** - 智能目录跳转
- **Eza** - 现代化 ls 替代品
- **Bat** - 现代化 cat 替代品
- **Terminal-Icons** - 文件图标模块

### 可选工具

- **Fzf** + **PSFzf** - 模糊搜索
- **Vfox** - 多语言版本管理器

> 💡 **提示**：配置文件具有优雅降级功能，即使某些工具未安装也不会报错，会自动使用系统默认命令。

---

## 🎨 自定义配置

### 使用固定 Oh My Posh 主题

编辑 `$PROFILE`，找到主题配置部分：

```powershell
# 原代码（随机主题）
$theme = $existingThemes | Get-Random

# 修改为固定主题（例如 atomic）
$theme = Get-Item "$themesPath/atomic.omp.json"
```

### 添加自定义别名

在配置文件末尾添加：

```powershell
# 自定义别名
Set-Alias -Name np -Value notepad
function cdp { Set-Location C:\Projects }
function cdd { Set-Location C:\Downloads }
```

### 修改 Windows Terminal 背景图片

编辑 `Terminal\settings.json`：

```json
"backgroundImage": "C:\\Your\\Path\\To\\Image.jpg",
"backgroundImageOpacity": 0.4
```

---

## 🔧 常见问题

### 图标显示为方块？

需要安装 Nerd Font 字体：

```powershell
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF

# 在 Windows Terminal 设置中选择该字体
# 设置 → 配置文件 → 默认 → 外观 → 字体 → JetBrainsMono Nerd Font Mono
```

### 工具不生效？

检查工具是否正确安装：

```powershell
# 检查工具
Get-Command eza, bat, zoxide, oh-my-posh

# 重新安装
scoop install eza bat zoxide oh-my-posh

# 重新加载配置
Update-Profile
```

### 启动速度慢？

1. 使用固定主题（不随机选择）
2. 禁用 Fastfetch 系统信息显示
3. 升级到 PowerShell 7+

更多问题请查看 [PowerShell配置文档.md](PowerShell-Enhanced-Profile/PowerShell配置文档.md) 的故障排查章节。

---

## 📊 性能数据

| 指标 | v2.0 | v2.1 | 提升 |
|------|------|------|------|
| 启动速度 | ~0.35秒 | ~0.28秒 | **20%** ⬆️ |
| 命令检测次数 | ~15次 | ~8次 | **47%** ⬇️ |
| PSReadLine 补全 | History | HistoryAndPlugin | **更智能** |

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个 Pull Request

---

## 📝 更新日志

### v2.1 (2025-11-12)

**性能优化**:
- ⚡ 启动速度提升 20%
- 🔧 工具检测缓存机制
- 📊 PSReadLine 升级为 HistoryAndPlugin 模式
- 🕐 日志输出添加时间戳
- ✅ 新增 `Test-Environment` 一键环境检查

### v2.0 (2025-11-12)

**新增**:
- ✅ 完整的错误处理机制
- ✅ 工具存在性检查
- ✅ 优雅降级支持
- ✅ 新增实用函数（mkcd, Find-LargeFiles 等）

详细更新日志请查看 [PowerShell配置文档.md](PowerShell-Enhanced-Profile/PowerShell配置文档.md)

---

## 📄 许可证

本项目采用 [MIT 许可证](LICENSE)

---

## 🙏 致谢

感谢以下开源项目：

- [Oh My Posh](https://ohmyposh.dev/) - 主题引擎
- [Scoop](https://scoop.sh/) - Windows 包管理器
- [PSReadLine](https://github.com/PowerShell/PSReadLine) - PowerShell 命令行增强
- [Zoxide](https://github.com/ajeetdsouza/zoxide) - 智能目录跳转
- [Eza](https://github.com/eza-community/eza) - 现代化 ls
- [Bat](https://github.com/sharkdp/bat) - 现代化 cat
- [Fzf](https://github.com/junegunn/fzf) - 模糊搜索

---

<div align="center">

**⭐ 如果这个项目对你有帮助，请给个 Star！**

Made with ❤️ for Windows Developers

</div>

