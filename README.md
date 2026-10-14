# 🚀 Windows 终端全家桶终极美化与极速工作流配置

<div align="center">

![PowerShell](https://img.shields.io/badge/PowerShell-7.4+-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Windows Terminal](https://img.shields.io/badge/Windows%20Terminal-Latest-4D4D4D?style=for-the-badge&logo=windows-terminal&logoColor=white)
![Package Manager](https://img.shields.io/badge/WinGet-First%20Priority-0078D4?style=for-the-badge&logo=windows&logoColor=white)
![Mirror](https://img.shields.io/badge/USTC%20Mirror-Accelerated-D83B01?style=for-the-badge&logo=speedtest&logoColor=white)
![Fallback](https://img.shields.io/badge/Scoop-Domestic%20Fallback-F25022?style=for-the-badge&logo=git&logoColor=white)
![NuShell](https://img.shields.io/badge/NuShell-Latest-245361?style=for-the-badge&logo=nushell&logoColor=white)
![CMD + Clink](https://img.shields.io/badge/CMD-Clink%20Enhanced-4EAA25?style=for-the-badge&logo=windows&logoColor=white)
![Starship](https://img.shields.io/badge/Starship-Cross--Shell-DD0B78?style=for-the-badge&logo=starship&logoColor=white)
![Theme](https://img.shields.io/badge/Theme-Catppuccin%20Mocha-CBA6F7?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)

**专为 Windows 开发者深度打磨的全终端、跨 Shell 现代化生产力开发套件**<br>
*WinGet 优先 • 中科大高速源 • Scoop 镜像备选 • 统一 Catppuccin Mocha 美学 • PSReadLine 智能预测 • 多维模糊检索 • 全自动快照与秒级回退*

[⚡ 快速开始](#-快速开始) • [📖 一步步详细安装教程](INSTALL_GUIDE.md) • [🖥️ 全终端支持矩阵](#️-全终端支持矩阵) • [🛠️ 核心工具矩阵](#️-核心工具链矩阵) • [🛡️ 快照与一键回退](#️-灾难恢复与一键无损回退系统) • [🔑 快捷别名速查](#-全终端常用快捷别名) • [📋 完整审计报告](TERMINAL_AUDIT_REPORT.md)

</div>

---

## 📖 项目简介

这是一套为 Windows 开发者倾力打造的**全终端、跨 Shell** 现代化开发环境套件。不仅具备高颜值的 Catppuccin Mocha 赛博朋克深色美学，更深入底层打通了命令预测、智能目录跳转、极速模糊检索、全键盘交互、国内高速网络下载以及 100% 可逆的配置快照回退。

无论您习惯在日常中使用哪种终端，均可获得一致的丝滑操作与顶级视觉质感：
- ⚡ **[PowerShell 7+ 高阶配置文件](PowerShell-Enhanced-Profile/README.md)** - 工业级 Profile，采用 AST 进程沙箱隔离，集成 Oh My Posh / Starship、PSReadLine 智能历史预测、超时保护与代码全文检索
- 🖥️ **[Windows Terminal 核心外观](Terminal/README.md)** - Catppuccin Mocha 精调深色主题、88% 亚克力毛玻璃半透明、多层 Nerd Font 字体回退链与直觉快捷分屏
- 💻 **[CMD + Clink 现代化增强](CMD/README.md)** - 让原生 CMD 拥有 24-bit 语法着色、实时智能补全、历史去重与 Bash 风格现代化 Doskey 别名，严格保证无 BOM UTF-8 与 CRLF 换行安全
- 🐚 **[NuShell 结构化现代终端](Nushell/README.md)** - 基于结构化管道的高性能现代 Shell，集成圆角精致表格、Fastfetch 看板、自动加载 Starship 与 Zoxide
- 🐧 **[Bash (Git Bash & MSYS2)](Bash/README.md)** - 自动打通 Windows 原生 CLI 工具链穿透，支持 UTF-8 中文环境、Television、Tre 与高频别名
- 🚀 **[Starship 跨 Shell 统一提示符](Starship/README.md)** - 赛博朋克霓虹双行提示符，针对 Windows NTFS 磁盘 I/O 深度调优防掉帧
- 🐱 **[Fastfetch 硬件动漫看板](Fastfetch/README.md)** - 精美二次元 ASCII 字符画与详尽系统硬件状态（CPU/GPU/内存/双屏/内网IP），强制 TrueColor 渲染
- 🦆 **[Yazi 双栏终端文件管理器](yazi/README.md)** - 基于 Rust 的极致快速文件管理面板，退出时当前路径自动同步回到终端

---

## ✨ 核心特性与架构升级

- 🚀 **中国高速网络优化（WinGet 优先 + 中科大源）**：
  - 核心 CLI 依赖工具与 JetBrainsMono Nerd Font **100% 优先采用 Windows 原生 WinGet** 安装；
  - 内置支持**中国科学技术大学 (USTC) 软件源**（`https://mirrors.ustc.edu.cn/winget-source`），彻底摆脱国内连接 GitHub 与海外 CDN 下载慢、频繁超时的困扰；
  - 若在普通权限下运行，自动支持申请 UAC 提权快速切换源，亦可一键重置回微软官方源。
- 🛡️ **Scoop 国内加速备选容错**：
  - 在无 WinGet 环境或遇阻时，自动降级为 Scoop 备选方案；
  - 搭载 `gh-proxy` 与 `gitee` 仓库镜像，解决 Scoop 官方 Bucket 添加失败的问题。
- 🔤 **JetBrainsMono Nerd Font 三级渐进式极速安装**：
  - 级联顺序：`WinGet 官方源` ➔ `国内加速镜像直链高速下载 + Windows 原生免重启即时注册` ➔ `Scoop nerd-fonts`；
  - 配合原生 C# GDI / User32 API 消息广播，安装后立刻生效，无需注销或重启系统。
- 💾 **全终端配置快照与一键秒级回退系统**：
  - 参考 `powershelldome` 架构标准，在每次修改系统前强制生成带 SHA-256 哈希审计与时间戳的完整快照清单 (`manifest.json`)；
  - 配套提供专用的 [`Restore-All.ps1`](Restore-All.ps1) 脚本，支持任何时刻一键无损还原所有文件与注册表项。
- 🎨 **全终端统一 Catppuccin Mocha 顶级视觉美学**：
  - 所有 Shell 遵循统一的 ANSI 16 色与十六进制配色规范，告别乱码与风格割裂。
- ⚡ **毫秒级极速响应与启动防假死**：
  - Starship 优化 `scan_timeout = 150`，消除 Windows 平台大型代码库 I/O 超时告警；
  - PowerShell AST 进程沙箱限制初始化超时（< 1500ms），绝不因外部依赖导致终端启动卡死。

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

## 🛠️ 核心工具链矩阵

所有核心生产力工具均可通过自动化脚本一键就绪：

| 工具名称 | 核心作用与替代对象 | WinGet ID (首选) | Scoop ID (备选) | 校验命令 |
| :--- | :--- | :--- | :--- | :--- |
| **PowerShell 7** | 现代化跨平台核心 Shell | `Microsoft.PowerShell` | `pwsh` | `pwsh` |
| **Git** | 分布式版本控制核心 | `Git.Git` | `git` | `git` |
| **Starship** | 跨终端统一极速双行提示符 | `Starship.Starship` | `starship` | `starship` |
| **Oh My Posh** | 高颜值主题提示符引擎 | `JanDeDobbeleer.OhMyPosh` | `oh-my-posh` | `oh-my-posh` |
| **Fastfetch** | 硬件信息与二次元动漫字符看板 | `Fastfetch-cli.Fastfetch` | `fastfetch` | `fastfetch` |
| **Eza** | 现代化文件列表（带图标，替代 `ls`） | `eza-community.eza` | `eza` | `eza` |
| **Bat** | 语法高亮代码查看（替代 `cat`） | `sharkdp.bat` | `bat` | `bat` |
| **Zoxide** | 基于权重与访问频次的目录智能瞬移 | `ajeetdsouza.zoxide` | `zoxide` | `zoxide` |
| **Fzf** | 命令行通用模糊搜索交互器 | `junegunn.fzf` | `fzf` | `fzf` |
| **Television** | 跨文件/代码/Git 多频道模糊检索 (`tv`) | `alexpasmantier.television` | `television` | `tv` |
| **Tre** | 现代彩色树状目录，附带数字编号打开 | `duan.tre` | `tre` | `tre` |
| **Clink** | 原生 CMD 24-bit 着色与智能补全引擎 | `chrisant996.Clink` | `clink` | `clink` |
| **NuShell** | 基于结构化数据管道的现代化 Shell | `Nushell.Nushell` | `nushell` | `nu` |
| **Yazi** | 基于 Rust 的极速双栏终端文件管理器 | `sxyazi.yazi` | `yazi` | `yazi` |
| **LazyGit** | 全键盘交互式终端 Git 控制台 | `JesseDuffield.lazygit` | `lazygit` | `lazygit` |
| **Neovim** | 现代化高扩展模态文本编辑器 | `Neovim.Neovim` | `neovim` | `nvim` |
| **Ripgrep** | 极速多线程文本检索 (`rg`) | `BurntSushi.ripgrep.MSVC` | `ripgrep` | `rg` |
| **Fd** | 现代化快速文件搜索工具 (`fd`) | `sharkdp.fd` | `fd` | `fd` |
| **Nerd Font** | JetBrainsMono 图标字体（解决乱码） | `DEVCOM.JetBrainsMonoNerdFont` | `nerd-fonts/JetBrainsMono-NF` | 字体库 |

---

## 🎯 快速开始

> 💡 **详细图文安装说明**：如需了解每一项工具的安装细节与常见问题解答，请参阅专门的 **[📖 一步步详细安装教程 (INSTALL_GUIDE.md)](INSTALL_GUIDE.md)**。

### 方式 1：一键自动化向导安装（强烈推荐）

在 PowerShell 中执行以下命令（首次执行建议确保执行策略允许）：

```powershell
# 1. 允许当前用户运行 PowerShell 脚本
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# 2. 克隆本仓库并进入目录
git clone https://github.com/viertelo/my-Windows-terminal-configuration.git
cd my-Windows-terminal-configuration

# 3. 运行自动化部署向导
.\install.ps1
```

执行后将展示清爽直观的交互式菜单：

```text
========================================================================
  Windows 终端全家桶 交互式部署向导
========================================================================
  1) 🚀 全自动一键部署 (配置WinGet中科大高速源 + WinGet极速安装依赖 + 备份并部署全部终端) [回车默认]
  2) ⚡ 快速安装依赖与字体 (仅使用 WinGet/Scoop 安装核心工具与 Nerd Font)
  3) 📁 仅部署终端配置文件 (自动安全备份，不下载依赖，适合已有工具者)
  4) 🇨🇳 配置/切换 WinGet 中国高速下载源 (中科大 USTC 镜像)
  5) 🔄 重置 WinGet 为微软官方默认源
  6) 💾 立即备份当前所有终端配置
  7) ⏪ 从最近的快照一键回退/还原配置
  8) 🚪 退出
```

直接按下 **Enter（回车）**，脚本将自动配置中科大高速镜像源、全速安装所需依赖与字体、生成安全备份并部署所有终端！

#### 命令行非交互式静默参数
如果您希望将安装集成到 CI 流程或快速静默执行，支持以下参数：

```powershell
# 一键静默全自动安装与部署全部环境
.\install.ps1 -All

# 仅部署配置文件 (自动安全备份，不安装依赖)
.\install.ps1 -ConfigOnly

# 仅安装依赖工具与 Nerd Font 图标字体
.\install.ps1 -ToolsOnly

# 仅配置 WinGet 中科大高速镜像源 (非管理员会自动弹出 UAC 提权)
.\install.ps1 -SetupWingetMirror

# 重置 WinGet 为微软官方 CDN 软件源
.\install.ps1 -ResetWingetMirror

# 仅执行当前环境配置安全快照归档
.\install.ps1 -BackupOnly

# 从最近一次快照一键无损回退
.\install.ps1 -Restore

# 查看详细帮助手册
.\install.ps1 -Help
```

---

### 方式 2：手动分步安装

若您希望手动安装核心工具并挑选部分终端进行部署：

```powershell
# 1. 使用 WinGet 安装全套核心工具与图标字体
winget install Microsoft.PowerShell Git.Git Starship.Starship JanDeDobbeleer.OhMyPosh Fastfetch-cli.Fastfetch eza-community.eza sharkdp.bat ajeetdsouza.zoxide junegunn.fzf alexpasmantier.television duan.tre chrisant996.Clink Nushell.Nushell sxyazi.yazi JesseDuffield.lazygit Neovim.Neovim BurntSushi.ripgrep.MSVC sharkdp.fd DEVCOM.JetBrainsMonoNerdFont --accept-source-agreements --accept-package-agreements

# 2. 安装 PowerShell 增强模块
Install-Module PSReadLine, Terminal-Icons, PSFzf -Scope CurrentUser -Force -SkipPublisherCheck

# 3. 克隆仓库并部署配置文件
git clone https://github.com/viertelo/my-Windows-terminal-configuration.git
cd my-Windows-terminal-configuration

# 部署 Windows Terminal 配置
Copy-Item .\Terminal\settings.json "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Force

# 部署 PowerShell Profile
Copy-Item .\PowerShell-Enhanced-Profile\Microsoft.PowerShell_profile.ps1 $PROFILE -Force

# 部署 CMD & Clink (无 BOM UTF-8 + CRLF + AutoRun 注册)
Copy-Item .\CMD\autorun.cmd "$env:USERPROFILE\.config\cmd\autorun.cmd" -Force
Copy-Item .\CMD\clink\* "$env:LOCALAPPDATA\clink\" -Force
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "@if exist `"%USERPROFILE%\.config\cmd\autorun.cmd`" call `"%USERPROFILE%\.config\cmd\autorun.cmd`"" /f

# 部署 NuShell 配置
Copy-Item .\Nushell\config.nu "$env:APPDATA\nushell\config.nu" -Force
Copy-Item .\Nushell\env.nu "$env:APPDATA\nushell\env.nu" -Force
Copy-Item -Recurse .\Nushell\vendor "$env:APPDATA\nushell\" -Force

# 部署 Git Bash 配置
Copy-Item .\Bash\.bashrc "$env:USERPROFILE\.bashrc" -Force
Copy-Item .\Bash\.bash_profile "$env:USERPROFILE\.bash_profile" -Force

# 部署通用视觉套件 (Starship / Fastfetch / Yazi)
Copy-Item .\Starship\starship.toml "$env:USERPROFILE\.config\starship.toml" -Force
Copy-Item -Recurse .\Fastfetch "$env:USERPROFILE\.config\fastfetch" -Force
Copy-Item .\yazi\*.toml "$env:APPDATA\yazi\config\" -Force
```

---

## 🛡️ 灾难恢复与一键无损回退系统

为了让您能够放心地在已有生产机器上体验本配置，项目参考了 `powershelldome` 架构，内置了完善的状态机与快照系统：

1. **自动快照归档**：
   每次执行配置部署前，系统会自动在 `$env:USERPROFILE\.terminal_backup_<时间戳>` 下生成安全备份，记录受管文件的原始内容、SHA-256 哈希校验值以及注册表当前状态，并在项目根目录生成 `.last-install-backup` 指针。
2. **一键秒级还原**：
   若您需要彻底还原到安装前的状态，只需在根目录运行专门的还原脚本：
   ```powershell
   .\Restore-All.ps1
   ```
3. **安全演练预览 (`-WhatIf`)**：
   在不实际触碰磁盘与注册表的前提下预览还原操作：
   ```powershell
   .\Restore-All.ps1 -WhatIf
   ```
   > 还原引擎会自动：还原被覆盖的原始文件、删除安装过程中新创建的文件、精确恢复 CMD AutoRun 注册表项。

---

## 🔑 全终端常用快捷别名

所有终端（PowerShell / CMD / NuShell / Bash）均对齐了高频开发指令，操作习惯完全统一：

| 别名 | 底层依赖 | 功能说明 |
| :--- | :--- | :--- |
| `ls` / `ll` / `la` | `eza` | 现代文件列表，带分类图标、色彩、Git 状态与文件夹前置 |
| `lt` / `lt3` | `eza --tree` | 深度为 2 / 3 层的精致树状目录展示 |
| `tre` | `tre -e` | 现代彩色树状目录，支持数字标号快速唤起编辑器打开 |
| `tv` / `tvd` / `tvf` | `television` | 交互式多频道模糊检索（全能频道 / 目录频道 / 文件频道） |
| `tvt` / `tvb` | `television` | 代码全文快速模糊检索 / Git 分支专属检索 |
| `cat` / `catc` / `catp` | `bat` | 代码语法高亮查看（免锁屏分页 / 交互式分页） |
| `z <关键字>` | `zoxide` | 智能跨级目录秒级跳转（支持权重模糊匹配） |
| `y` | `yazi` | 启动 Yazi 终端双栏文件管理器（**退出自动同步 Shell 当前路径**） |
| `fif <关键词>` | `rg + fzf + bat` | （PowerShell）全局代码模糊检索带右侧实时语法高亮画中画预览 |
| `gst` / `ga` / `gc` | `git` | Git 极速工作流：状态查看 / 暂存变更 / 快速提交 |
| `gundo` | `git reset` | 撤销上一次提交但保留本地所有工作区修改 (`HEAD~1`) |
| `lg` | `lazygit` | 启动全键盘交互式终端 Git 控制台 |
| `v` / `c` | `nvim` / `code` | 快速唤起 Neovim / VS Code 编辑器 |
| `ports` | `netstat` | 格式化查看当前系统各端口监听状态与对应 PID |
| `myip` | `fastfetch` | 快速查看本机各物理与虚拟网卡内网 IP 地址 |
| `..` / `...` / `....` | `cd` | 快速向上跃迁 1 / 2 / 3 级父目录 |

---

## ⌨️ 常用全局快捷键速查

| 快捷键 | 生效终端 | 功能说明 |
| :--- | :--- | :--- |
| `→` / `End` | PowerShell | 一键采纳 PSReadLine 智能历史预测建议 |
| `Ctrl+R` | PowerShell / CMD | 模糊搜索历史执行过的命令行并回填 |
| `Ctrl+F` | PowerShell | 交互式模糊挑选当前目录文件并回填至命令行 |
| `Ctrl+G` | PowerShell | 瞬间唤起 Lazygit 面板，退出后无缝恢复原提示符 |
| `Alt+Z` | PowerShell | 交互式唤出 Zoxide 访问历史目录并瞬间跳转 |
| `F2` | PowerShell | 切换历史预测视图（内联预测模式 ⟷ 下拉多行列表模式） |
| `Ctrl+Shift+P` | Windows Terminal | 调出终端全局命令面板 (Command Palette) |
| `Alt+Shift+D` | Windows Terminal | 自动拆分窗格（沿最长边分割当前 Shell 视窗） |
| `Alt+Shift+-` / `+` | Windows Terminal | 水平 / 垂直拆分出新窗格 |
| `Alt+方向键` | Windows Terminal | 在多个分屏窗格之间快速切换焦点 |

---

## ⚙️ 环境变量与个性化开关

您可以在系统环境变量或个人 Profile 顶部声明以下开关，自由定制开屏体验：

| 环境变量 | 默认值 | 开关说明 |
| :--- | :---: | :--- |
| `POWERSHELL_PROFILE_BANNER` | `1` | 设为 `0` 跳过 PowerShell 开屏 Fastfetch 看板（追求极致冷启动速度） |
| `POWERSHELL_PROFILE_TIPS` | `1` | 设为 `0` 跳过开屏功能指引卡片 |
| `POWERSHELL_THEME_MODE` | `oh-my-posh` | 设为 `starship` 将 PowerShell 提示符切换为 Starship 赛博朋克主题 |
| `POWERSHELL_PROFILE_ICONS` | `1` | 设为 `0` 跳过 Terminal-Icons 图标库加载 |
| `CMD_PROFILE_BANNER` | `1` | 设为 `0` 跳过 CMD 开屏 Fastfetch 看板 |
| `CMD_PROFILE_TIPS` | `1` | 设为 `0` 跳过 CMD 开屏快捷指令提示卡片 |

---

## 📁 项目文件架构全景

```text
my-Windows-terminal-configuration/
├── install.ps1                            # 核心自动化安装与部署向导 (WinGet优先/中科大源/菜单/CLI参数)
├── Restore-All.ps1                        # 全终端配置一键回退与灾难恢复脚本 (支持 -WhatIf)
├── INSTALL_GUIDE.md                       # 一步步详细安装与部署教程
├── README.md                              # 项目总览说明与完整技术手册
├── TERMINAL_AUDIT_REPORT.md               # 全终端架构审计报告与 SHA-256 哈希基准表
├── .gitignore                             # Git 忽略状态指针与备份文件
├── .gitattributes                         # 跨平台换行符规范守护 (强制 CMD/BAT 维持 CRLF)
├── scripts/
│   ├── TerminalSetupCommon.ps1            # 环境检查、WinGet源配置、工具安装引擎、字体注册公共库
│   └── TerminalState.ps1                  # 配置目标清册、原子替换、状态快照与回退引擎
├── Bash/
│   ├── .bashrc                            # Git Bash 核心配置 (Windows PATH穿透、别名、tvcd、Starship)
│   ├── .bash_profile                      # 登录 Shell 引导文件
│   └── msys2.bashrc                       # MSYS2 完整环境配置文件
├── CMD/
│   ├── autorun.cmd                        # CMD 自动注入脚本 (UTF-8无BOM、CRLF保护、Doskey别名)
│   └── clink/                             # Clink 增强引擎 (24-bit着色、实时补全、Starship过滤器)
├── Fastfetch/
│   ├── config.jsonc                       # 结构化硬件遥测规格配置
│   └── ascii.txt                          # 定制高精二次元动漫 ASCII 字符艺术画
├── Nushell/
│   ├── config.nu                          # NuShell 核心配置 (圆角表格、高频别名、tvcd)
│   ├── env.nu                             # NuShell 环境变量与 autoload 初始化
│   └── vendor/autoload/                   # Starship 与 Zoxide 自动加载模块
├── PowerShell-Enhanced-Profile/
│   ├── Microsoft.PowerShell_profile.ps1   # 工业级 Profile (AST进程沙箱隔离、预测补全、极速加载)
│   └── 快速参考.md                        # PowerShell 专属高频操作速查卡片
├── Starship/
│   └── starship.toml                      # 跨终端统一赛博朋克霓虹双行提示符配置 (NTFS I/O优化)
├── Terminal/
│   └── settings.json                      # Windows Terminal 核心外观 (Catppuccin Mocha、毛玻璃透明、按键)
└── yazi/
    ├── yazi.toml                          # Yazi 核心行为与预览器配置
    ├── keymap.toml                        # 全局全键盘按键映射
    ├── theme.toml                         # Catppuccin Mocha 色彩主题
    ├── Yazi快捷键操作手册.md              # Yazi 全键盘操作速查清单
    └── Yazi文件类型与打开方式配置说明.md   # 打开方式规则与外部工具绑定
```

---

## ❓ 常见问题与故障排查 (FAQ)

### Q1: 提示“无法加载文件，因为在此系统上禁止运行脚本”？
**解答**：Windows 默认禁止执行未经数字签名的本地脚本。只需在终端运行一次以下指令即可永久解除当前用户限制：
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

### Q2: 切换中科大镜像源时提示需要管理员权限？
**解答**：WinGet 修改系统级软件源（`winget source remove/add`）属于 Windows 系统安全敏感操作。运行 `.\install.ps1` 时若检测到非管理员权限，会弹出 UAC 提权确认框；点击“是”即可自动完成配置并无缝返回。若选择跳过，脚本会自动使用微软现有源继续安装。

### Q3: 终端中部分 Git 符号或文件图标显示为方块或问号乱码？
**解答**：这是因为当前终端使用的字体不是 **Nerd Font**。
1. 运行 `.\install.ps1`（选项 2）会自动安装并注册 **JetBrainsMono Nerd Font**；
2. 确保在 Windows Terminal 设置或 `settings.json` 的 `"font": { "face": "JetBrainsMono NFM" }` 中正确配置了该字体。

### Q4: 原生 CMD 启动时出现 `'锘緻echo'` 或语法断裂报错？
**解答**：这是由于批处理文件被某些现代编辑器错误保存为了带有 UTF-8 BOM 头或 Unix LF 换行符导致的。本项目自带的 `install.ps1` 在部署 `CMD/autorun.cmd` 时，强制施加了 **无 BOM UTF-8 (UTF-8 without BOM)** 编码与 **CRLF (`\r\n`)** 换行校验，彻底杜绝此类解析异常。

### Q5: 如何一键撤销并恢复我以前的终端配置？
**解答**：直接在仓库根目录执行：
```powershell
.\Restore-All.ps1
```
脚本将读取部署时自动创建的快照，把所有配置文件与注册表项无损恢复至安装前状态。

---

## 📚 详细子文档索引

每个终端与工具模块均配有专属的深度配置与使用文档：

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

欢迎提交 Issue 和 Pull Request 一同完善 Windows 终端开发体验！

本项目基于 [MIT 许可证](LICENSE) 开源。

<div align="center">

Made with ❤️ for Windows Developers

</div>
