# 🚀 Windows 终端全家桶完美美化与极速工作流配置

<div align="center">

![PowerShell](https://img.shields.io/badge/PowerShell-7.4+-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Windows Terminal](https://img.shields.io/badge/Windows%20Terminal-Latest-4D4D4D?style=for-the-badge&logo=windows-terminal&logoColor=white)
![NuShell](https://img.shields.io/badge/NuShell-Latest-245361?style=for-the-badge&logo=nushell&logoColor=white)
![Git Bash](https://img.shields.io/badge/Git%20Bash-Latest-F05032?style=for-the-badge&logo=git&logoColor=white)
![Starship](https://img.shields.io/badge/Starship-Cross--Shell-DD0B78?style=for-the-badge&logo=starship&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/platform-Windows%2010/11-0078D6?style=for-the-badge&logo=windows&logoColor=white)

**为 Windows 开发者打造的全终端现代化、高生产力开发环境套件**

[快速开始](#-快速开始) • [📖 一步步详细安装教程](INSTALL_GUIDE.md) • [多终端矩阵](#-全终端支持矩阵) • [核心特性](#-功能特性) • [📋 审计报告](TERMINAL_AUDIT_REPORT.md)

</div>

---

## 📖 项目简介

这是一套为 Windows 开发者深度打磨的**全终端、跨 Shell** 现代化配置方案。不仅包含高颜值的界面美化，更深入底层打通了命令预测、智能跳转、极速模糊检索、全键盘交互与多工具链无缝联动。

涵盖主流终端与 Shell 全生态：
- ⚡ **[PowerShell 7+ 高阶配置文件](PowerShell-Enhanced-Profile/README.md)** - 工业级 Profile，集成 Oh My Posh、PSReadLine 智能预测、超时保护与代码全文检索
- 🖥️ **[Windows Terminal 核心外观](Terminal/README.md)** - Catppuccin Mocha 精调主题、背景透明度、多层字体回退链与直觉分屏
- 💻 **[CMD + Clink 终极增强](CMD/README.md)** - 让原生 CMD 拥有智能补全、24-bit 语法着色、历史搜索与 Bash 风格现代化别名
- 🐚 **[NuShell 结构化现代终端](Nushell/README.md)** - 极速管道 Shell，集成圆角表格、Fastfetch 看板、自动加载 Starship 与 Zoxide
- 🐧 **[Bash (Git Bash / MSYS2)](Bash/README.md)** - 自动打通 Windows 原生 CLI 工具链，支持 UTF-8 编码、Television、Tre 与高频别名
- 🚀 **[Starship 跨 Shell 统一提示符](Starship/README.md)** - 双行赛博朋克提示符，优化 Windows I/O 超时防掉帧
- 🐱 **[Fastfetch 硬件动漫看板](Fastfetch/README.md)** - 精美系统信息展示，动漫字符画与硬件状态实时呈现
- 🦆 **[Yazi 双栏终端文件管理器](Yazi/README.md)** - 基于 Rust 的极致快速文件管理面板

---

## 🖥️ 全终端支持矩阵

| 终端 / Shell | 核心增强技术 | 提示符引擎 | 智能补全 / 检索 | 配置文件所在目录 |
| :--- | :--- | :--- | :--- | :--- |
| **PowerShell 7+** | PSReadLine / PSFzf / UTF-8 | Oh My Posh / Starship | Television (`tv`), Tre, Zoxide | `PowerShell-Enhanced-Profile/` |
| **Windows Terminal** | Catppuccin Mocha / Nerd Font | 终端顶层渲染 | 快捷分屏 / 快速搜索 | `Terminal/` |
| **CMD (命令提示符)** | Clink 引擎 / Doskey 注入 | Starship (Clink Filter) | Clink 自动补全 / Doskey 别名 | `CMD/` |
| **NuShell** | 结构化数据 / 圆角表格 | Starship (Autoload) | Television (`tvcd`), Zoxide | `Nushell/` |
| **Git Bash** | Windows PATH 穿透 / UTF-8 | Starship | Television (`tv`), Tre, Zoxide | `Bash/` |
| **MSYS2 Bash** | Windows PATH 穿透 / pacman | Starship | Television (`tv`), Tre, Zoxide | `Bash/` |

---

## ✨ 核心特性

- 🎨 **顶级美学与一致体验**：全 Shell 统一色彩主题，无乱码，全支持 Nerd Font 图标。
- 🔍 **多维模糊检索工具链**：
  - **Television (`tv`)**：跨文件、目录、代码全文与 Git 分支的多频道极速检索。
  - **Tre (`tre`)**：智能树状目录，附带数字编号，支持快速打开目标文件。
  - **Zoxide (`z`)**：基于使用频次的跨层级目录智能秒级跳转。
- ⚡ **毫秒级极速响应**：Starship 优化 `scan_timeout = 150`，消除 Windows 磁盘 I/O 警告；PowerShell 智能缓存，启动耗时 < 0.3s。
- 🛡️ **工业级容错与优雅降级**：所有终端配置均具备工具存在性自检，缺少任一工具均平滑降级，绝不弹窗报错。
- 📦 **100% 本地与仓库双向同步**：所有配置文件经过严苛的 SHA-256 哈希审计与验证（详见 [TERMINAL_AUDIT_REPORT.md](TERMINAL_AUDIT_REPORT.md)）。

---

## 🎯 快速开始

> 💡 **详细教程推荐**：如需图文并茂的逐步安装教学与常见问题排查，请参阅专门的 **[📖 一步步详细安装教程 (INSTALL_GUIDE.md)](INSTALL_GUIDE.md)**。

### 方式 1：一键自动化安装脚本（推荐）

本项目附带了自动化交互式部署脚本 `install.ps1`，支持自动备份旧配置、一键安装 Scoop 依赖与字体、全量部署所有终端：

```powershell
# 1. 允许当前用户运行 PowerShell 脚本
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# 2. 克隆本仓库
git clone https://github.com/viertelo/my-Windows-terminal-configuration.git
cd my-Windows-terminal-configuration

# 3. 运行自动化部署向导
.\install.ps1
```

### 方式 2：手动分步安装

若您希望手动安装核心工具并挑选部分终端进行部署：

```powershell
# 1. 安装核心工具链（通过 Scoop）
scoop install git starship oh-my-posh fastfetch eza bat zoxide fzf television tre clink nushell yazi lazygit
scoop install JetBrainsMono-NF
```

### 2. 克隆本仓库

```powershell
git clone https://github.com/viertelo/my-Windows-terminal-configuration.git
cd my-Windows-terminal-configuration
```

### 3. 一键部署各终端配置

- **PowerShell 7+**：
  ```powershell
  Copy-Item .\PowerShell-Enhanced-Profile\Microsoft.PowerShell_profile.ps1 $PROFILE -Force
  ```
- **Windows Terminal**：
  将 `Terminal/settings.json` 覆盖至 Windows Terminal 配置目录：
  `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
- **CMD + Clink**：
  ```powershell
  Copy-Item .\CMD\autorun.cmd "$env:USERPROFILE\.config\cmd\autorun.cmd" -Force
  Copy-Item .\CMD\clink\* "$env:LOCALAPPDATA\clink\" -Force
  reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "%USERPROFILE%\.config\cmd\autorun.cmd" /f
  ```
- **NuShell**：
  ```powershell
  Copy-Item .\Nushell\config.nu "$env:APPDATA\nushell\config.nu" -Force
  Copy-Item .\Nushell\env.nu "$env:APPDATA\nushell\env.nu" -Force
  Copy-Item -Recurse .\Nushell\vendor "$env:APPDATA\nushell\" -Force
  ```
- **Git Bash**：
  ```powershell
  Copy-Item .\Bash\.bashrc "$env:USERPROFILE\.bashrc" -Force
  Copy-Item .\Bash\.bash_profile "$env:USERPROFILE\.bash_profile" -Force
  ```
- **Starship / Fastfetch / Yazi**：
  ```powershell
  Copy-Item .\Starship\starship.toml "$env:USERPROFILE\.config\starship.toml" -Force
  Copy-Item -Recurse .\Fastfetch "$env:USERPROFILE\.config\fastfetch" -Force
  Copy-Item -Recurse .\Yazi "$env:APPDATA\yazi\config" -Force
  ```

---

## 📚 文档中心

| 模块 | 文档链接 | 说明 |
| :--- | :--- | :--- |
| **PowerShell** | [PowerShell 完整开发文档](PowerShell-Enhanced-Profile/PowerShell配置文档.md) | 包含函数手册、模块优化与环境检查 |
| **Windows Terminal** | [Terminal 配置与快捷键说明](Terminal/README.md) | 包含配色方案、字体链与分屏配置 |
| **CMD & Clink** | [CMD 现代化改造指南](CMD/README.md) | 包含注册表 AutoRun 机制与 Clink Lua 脚本 |
| **NuShell** | [NuShell 现代工作流指南](Nushell/README.md) | 包含结构化数据配置、autoload 机制与 tvcd |
| **Bash & MSYS2** | [Windows Bash 配置指南](Bash/README.md) | 包含 Windows PATH 继承与环境适配 |
| **Starship** | [Starship 超时与渲染优化](Starship/README.md) | 消除 Windows I/O 警告最佳实践 |
| **系统审计报告** | [TERMINAL_AUDIT_REPORT.md](TERMINAL_AUDIT_REPORT.md) | 包含全量文件哈希比对与架构分析 |

---

## 🔑 全终端通用常用快捷别名

全套配置在所有终端中保持了极高的一致性：

| 别名 | 底层命令 | 说明 |
| :--- | :--- | :--- |
| `ls` / `ll` / `la` | `eza` | 现代文件列表，包含图标、色彩与 Git 状态 |
| `lt` / `lt3` | `eza --tree` | 深度为 2 / 3 的树状目录展示 |
| `tre` | `tre -e` | 现代树状目录，支持标号快速打开 |
| `tv` / `tvd` / `tvf` | `television` | 交互式多频道模糊检索（全能 / 目录 / 文件） |
| `tvt` / `tvb` | `television` | 代码全文快速检索 / Git 分支检索 |
| `cat` / `catp` | `bat` | 代码语法高亮查看（免分页 / 分页） |
| `z <关键字>` | `zoxide` | 智能跨级目录秒级跳转 |
| `y` | `yazi` | 启动 Yazi 终端双栏文件管理器 |
| `gst` / `ga` / `gc` | `git` | Git 状态 / 暂存 / 提交极速别名 |
| `lg` | `lazygit` | 启动全键盘终端 Git 界面 |
| `v` / `c` | `nvim` / `code` | 快速启动 Neovim / VS Code 编辑器 |

---

## 🤝 贡献与许可

欢迎提交 Issue 和 Pull Request！

本项目采用 [MIT 许可证](LICENSE)。

<div align="center">

Made with ❤️ for Windows Developers

</div>
