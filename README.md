# 🚀 Windows 终端全家桶终极美化与极速工作流配置

<div align="center">

![PowerShell](https://img.shields.io/badge/PowerShell-7.4+-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Windows Terminal](https://img.shields.io/badge/Windows%20Terminal-Latest-4D4D4D?style=for-the-badge&logo=windows-terminal&logoColor=white)
![NuShell](https://img.shields.io/badge/NuShell-Latest-245361?style=for-the-badge&logo=nushell&logoColor=white)
![CMD + Clink](https://img.shields.io/badge/CMD-Clink%20Enhanced-4EAA25?style=for-the-badge&logo=windows&logoColor=white)
![Git Bash](https://img.shields.io/badge/Git%20Bash-MSYS2-F05032?style=for-the-badge&logo=git&logoColor=white)
![Starship](https://img.shields.io/badge/Starship-Cross--Shell-DD0B78?style=for-the-badge&logo=starship&logoColor=white)
![Fastfetch](https://img.shields.io/badge/Fastfetch-TrueColor-F8B88B?style=for-the-badge&logo=arch-linux&logoColor=white)
![Yazi](https://img.shields.io/badge/Yazi-Rust%20TUI-EBCB8B?style=for-the-badge&logo=rust&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)

**专为 Windows 开发者打造的全终端现代化、高生产力开发环境套件**  
*统一 Catppuccin Mocha 美学 • PSReadLine 智能预测 • 多维模糊检索 • 毫秒级极速响应 • 优雅容错降级*

[⚡ 快速开始](#-快速开始) • [📖 一步步详细安装教程](INSTALL_GUIDE.md) • [🖥️ 全终端支持矩阵](#️-全终端支持矩阵) • [✨ 核心特性](#-核心特性) • [🔑 常用快捷别名](#-全终端常用快捷别名) • [📋 完整审计报告](TERMINAL_AUDIT_REPORT.md)

</div>

---

## 📖 项目简介

这是一套为 Windows 开发者深度打磨的**全终端、跨 Shell** 现代化配置方案。不仅包含高颜值的赛博朋克深色美化，更深入底层打通了命令预测、智能跳转、极速模糊检索、全键盘交互与多工具链无缝联动。

无论您习惯在日常中使用哪种终端，均可获得一致的丝滑操作与顶级视觉质感：
- ⚡ **[PowerShell 7+ 高阶配置文件](PowerShell-Enhanced-Profile/README.md)** - 工业级 Profile，采用 AST 进程沙箱隔离，集成 Oh My Posh / Starship、PSReadLine 智能预测、超时保护与代码全文检索
- 🖥️ **[Windows Terminal 核心外观](Terminal/README.md)** - Catppuccin Mocha 精调深色主题、88% 亚克力毛玻璃半透明、多层 Nerd Font 字体回退链与直觉快捷分屏
- 💻 **[CMD + Clink 现代化增强](CMD/README.md)** - 让原生 CMD 拥有 24-bit 语法着色、实时智能补全、历史搜索与 Bash 风格现代化 Doskey 别名
- 🐚 **[NuShell 结构化现代终端](Nushell/README.md)** - 基于结构化管道的高性能现代 Shell，集成圆角表格、Fastfetch 看板、自动加载 Starship 与 Zoxide
- 🐧 **[Bash (Git Bash & MSYS2)](Bash/README.md)** - 自动打通 Windows 原生 CLI 工具链，支持 UTF-8 中文环境、Television、Tre 与高频别名
- 🚀 **[Starship 跨 Shell 统一提示符](Starship/README.md)** - 赛博朋克霓虹双行提示符，针对 Windows NTFS 磁盘 I/O 深度调优防掉帧
- 🐱 **[Fastfetch 硬件动漫看板](Fastfetch/README.md)** - 精美二次元 ASCII 字符画与详尽系统硬件状态（CPU/GPU/内存/双屏/内网IP），强制 TrueColor 渲染
- 🦆 **[Yazi 双栏终端文件管理器](yazi/README.md)** - 基于 Rust 的极致快速文件管理面板，退出时当前路径自动同步回到终端

---

## 🖥️ 全终端支持矩阵

| 终端 / Shell | 核心增强技术 | 提示符引擎 | 智能补全 / 检索 | 配置文件所在目录 |
| :--- | :--- | :--- | :--- | :--- |
| **PowerShell 7+** | PSReadLine / PSFzf / UTF-8 | Oh My Posh / Starship | Television (`tv`), Tre, Zoxide | [`PowerShell-Enhanced-Profile/`](PowerShell-Enhanced-Profile/README.md) |
| **Windows Terminal** | Catppuccin Mocha / 亚克力透明 / Nerd Font | 终端顶层渲染 | 快捷分屏 / 快速搜索 | [`Terminal/`](Terminal/README.md) |
| **CMD (命令提示符)** | Clink 引擎 / UTF-8 无BOM / Doskey 注入 | Starship (Clink Filter) | Clink 自动补全 / Doskey 别名 | [`CMD/`](CMD/README.md) |
| **NuShell** | 结构化数据管道 / 圆角精致表格 | Starship (Autoload) | Television (`tvcd`), Zoxide | [`Nushell/`](Nushell/README.md) |
| **Git Bash** | Windows PATH 动态穿透 / UTF-8 语言环境 | Starship | Television (`tv`), Tre, Zoxide | [`Bash/`](Bash/README.md) |
| **MSYS2 Bash** | Windows PATH 穿透 / pacman / UTF-8 | Starship | Television (`tv`), Tre, Zoxide | [`Bash/`](Bash/README.md) |

---

## ✨ 核心特性

- 🎨 **顶级美学与一致体验**：
  全 Shell 统一遵循 **Catppuccin Mocha** 配色规范，消除字体缺失乱码，支持 Nerd Font 全套图标渲染。
- 🔍 **多维模糊检索工具链**：
  - **Television (`tv`)**：跨文件、目录、代码全文与 Git 分支的多频道交互式检索浮层。
  - **Tre (`tre`)**：彩色现代树状目录，附带数字编号，支持 `e1`, `e2` 快速打开目标文件。
  - **Zoxide (`z`)**：基于权重与访问频次的跨层级目录智能秒级瞬移。
  - **全局代码检索 (`fif`)**：结合 `ripgrep` + `fzf` + `bat` 实时画中画代码行预览检索。
- ⚡ **毫秒级极速启动**：
  - Starship 优化 `scan_timeout = 150`，消除 Windows 平台在大型代码库下的 I/O 超时告警；
  - PowerShell AST 进程沙箱限制初始化超时（< 1500ms），绝不因外部组件或网络波动导致终端卡死。
- 🛡️ **严格守护对象管道与编码安全**：
  - PowerShell 中保留原生 `ls` / `dir` / `cat` 为 Cmdlet 对象输出，不破坏 PowerShell 原生管道；
  - CMD 批处理强制施行 **无 BOM UTF-8 (UTF-8 without BOM)** 与 **CRLF** 换行符保护，杜绝 `'锘緻echo'` 与语法断裂。
- 📦 **100% 本地与仓库强校验同步**：
  全套 19 项配置文件经过严苛的 SHA-256 哈希审计（详见 [TERMINAL_AUDIT_REPORT.md](TERMINAL_AUDIT_REPORT.md)）。

---

## 🎯 快速开始

> 💡 **详细安装说明**：如需了解每一项工具的安装细节与常见问题解答，请参阅专门的 **[📖 一步步详细安装教程 (INSTALL_GUIDE.md)](INSTALL_GUIDE.md)**。

### 方式 1：一键自动化安装脚本（推荐）

本项目附带了自动化交互式部署脚本 [`install.ps1`](install.ps1)，支持自动备份旧配置、一键安装 Scoop 依赖工具与字体、全量部署所有终端：

```powershell
# 1. 允许当前用户运行 PowerShell 脚本
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# 2. 克隆本仓库
git clone https://github.com/viertelo/my-Windows-terminal-configuration.git
cd my-Windows-terminal-configuration

# 3. 运行自动化部署向导
.\install.ps1
```

在交互式向导中直接按回车（默认选项 1），即可全自动完成工具链与所有终端的部署！

---

### 方式 2：手动分步安装

若您希望手动安装核心工具并挑选部分终端进行部署：

```powershell
# 1. 安装核心工具链（通过 Scoop）
scoop install git starship oh-my-posh fastfetch eza bat zoxide fzf television tre clink nushell yazi lazygit neovim
scoop install JetBrainsMono-NF

# 2. 安装 PowerShell 增强模块
Install-Module PSReadLine, Terminal-Icons, PSFzf -Scope CurrentUser -Force -SkipPublisherCheck

# 3. 克隆仓库并选择性部署
git clone https://github.com/viertelo/my-Windows-terminal-configuration.git
cd my-Windows-terminal-configuration

# 部署 Windows Terminal
Copy-Item .\Terminal\settings.json "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Force

# 部署 PowerShell Profile
Copy-Item .\PowerShell-Enhanced-Profile\Microsoft.PowerShell_profile.ps1 $PROFILE -Force

# 部署 CMD & Clink (静默 AutoRun 注入)
Copy-Item .\CMD\autorun.cmd "$env:USERPROFILE\.config\cmd\autorun.cmd" -Force
Copy-Item .\CMD\clink\* "$env:LOCALAPPDATA\clink\" -Force
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "@if exist `"%USERPROFILE%\.config\cmd\autorun.cmd`" call `"%USERPROFILE%\.config\cmd\autorun.cmd`"" /f

# 部署 NuShell
Copy-Item .\Nushell\config.nu "$env:APPDATA\nushell\config.nu" -Force
Copy-Item .\Nushell\env.nu "$env:APPDATA\nushell\env.nu" -Force
Copy-Item -Recurse .\Nushell\vendor "$env:APPDATA\nushell\" -Force

# 部署 Git Bash
Copy-Item .\Bash\.bashrc "$env:USERPROFILE\.bashrc" -Force
Copy-Item .\Bash\.bash_profile "$env:USERPROFILE\.bash_profile" -Force

# 部署通用视觉套件 (Starship / Fastfetch / Yazi)
Copy-Item .\Starship\starship.toml "$env:USERPROFILE\.config\starship.toml" -Force
Copy-Item -Recurse .\Fastfetch "$env:USERPROFILE\.config\fastfetch" -Force
Copy-Item -Recurse .\yazi "$env:APPDATA\yazi\config" -Force
```

---

## 🔑 全终端常用快捷别名

所有终端均对齐了高频开发指令，操作习惯完全统一：

| 别名 | 底层命令 | 说明 |
| :--- | :--- | :--- |
| `ls` / `ll` / `la` | `eza` | 现代文件列表，带图标、色彩、Git 状态与文件夹前置 |
| `lt` / `lt3` | `eza --tree` | 深度为 2 / 3 层的树状目录展示 |
| `tre` | `tre -e` | 现代彩色树状目录，支持数字标号快速打开 |
| `tv` / `tvd` / `tvf` | `television` | 交互式多频道模糊检索（全能 / 目录 / 文件） |
| `tvt` / `tvb` | `television` | 代码全文快速检索 / Git 分支检索 |
| `cat` / `catc` / `catp` | `bat` | 代码语法高亮查看（免分页 / 分页） |
| `z <关键字>` | `zoxide` | 智能跨级目录秒级跳转（支持模糊匹配） |
| `y` | `yazi` | 启动 Yazi 终端双栏文件管理器（退出自动同步当前路径） |
| `fif <关键词>` | `rg + fzf + bat` | （PowerShell）全局代码模糊检索带实时高亮预览 |
| `gst` / `ga` / `gc` | `git` | Git 状态 / 暂存 / 提交极速快捷键 |
| `gundo` | `git reset` | 撤销上一次提交但保留工作区修改 (`HEAD~1`) |
| `lg` | `lazygit` | 启动全键盘交互式 Git 控制台 |
| `v` / `c` | `nvim` / `code` | 快速启动 Neovim / VS Code 编辑器 |
| `ports` | `netstat` | 格式化查看当前系统端口监听与占用 PID |
| `myip` | `fastfetch` | 快速查看本机各物理与虚拟网卡内网 IP |

---

## ⌨️ 常用全局快捷键速查

| 快捷键 | 生效范围 | 说明 |
| :--- | :--- | :--- |
| `→` / `End` | PowerShell | 一键采纳 PSReadLine 智能历史预测建议 |
| `Ctrl+R` | PowerShell / CMD | 模糊搜索历史执行过的命令并填入命令行 |
| `Ctrl+F` | PowerShell | 交互式挑选当前目录文件并填入当前命令行 |
| `Ctrl+G` | PowerShell | 瞬间唤起 Lazygit 面板，退出后无缝恢复原提示符 |
| `Alt+Z` | PowerShell | 交互式唤出 Zoxide 访问历史目录并瞬间跳转 |
| `Ctrl+Shift+P` | Windows Terminal | 调出全局命令面板 (Command Palette) |
| `Alt+Shift+D` | Windows Terminal | 自动拆分窗格（沿最长边分割当前 Shell 视窗） |
| `Alt+方向键` | Windows Terminal | 在多个分屏窗格之间无缝切换焦点 |

---

## ⚙️ 环境变量与个性化开关

可在系统环境变量或 Profile 顶部声明以下开关以自定义加载体验：

| 环境变量 | 默认值 | 说明 |
| :--- | :---: | :--- |
| `POWERSHELL_PROFILE_BANNER` | `1` | 设为 `0` 跳过 PowerShell 开屏 Fastfetch 看板（追求极限极速） |
| `POWERSHELL_PROFILE_TIPS` | `1` | 设为 `0` 跳过开屏功能指引卡片 |
| `POWERSHELL_THEME_MODE` | `oh-my-posh` | 设为 `starship` 将 PowerShell 提示符切换为 Starship 引擎 |
| `POWERSHELL_PROFILE_ICONS` | `1` | 设为 `0` 跳过 Terminal-Icons 加载 |
| `CMD_PROFILE_BANNER` | `1` | 设为 `0` 跳过 CMD 开屏 Fastfetch 看板 |
| `CMD_PROFILE_TIPS` | `1` | 设为 `0` 跳过 CMD 开屏快捷指令提示 |

---

## 📚 详细子文档索引

每个子模块均包含独立、详尽的使用与配置手册：

- ⚡ **[PowerShell 增强配置手册](PowerShell-Enhanced-Profile/README.md)** • [快速参考卡片](PowerShell-Enhanced-Profile/快速参考.md)
- 🖥️ **[Windows Terminal 核心外观与快捷键手册](Terminal/README.md)**
- 💻 **[CMD + Clink 现代化改造手册](CMD/README.md)**
- 🐚 **[NuShell 现代工作流手册](Nushell/README.md)**
- 🐧 **[Windows Bash (Git Bash & MSYS2) 配置手册](Bash/README.md)**
- 🚀 **[Starship 赛博朋克提示符手册](Starship/README.md)**
- 🐱 **[Fastfetch 硬件看板配置手册](Fastfetch/README.md)**
- 🦆 **[Yazi 双栏文件管理器手册](yazi/README.md)** • [快捷键完整操作手册](yazi/Yazi快捷键操作手册.md) • [文件关联说明](yazi/Yazi文件类型与打开方式配置说明.md)
- 📋 **[Windows 终端全家桶全面审计报告](TERMINAL_AUDIT_REPORT.md)**

---

## 🤝 贡献与许可

欢迎提交 Issue 和 Pull Request！

本项目采用 [MIT 许可证](LICENSE)。

<div align="center">

Made with ❤️ for Windows Developers

</div>
